

CREATE PROCEDURE [dbo].[HMRC_UpdateHistoryTable]
(@Run_Id bigint,@RetentionDate Date)
AS
-- ====================================================================================
-- Author:      Robin Rai
-- Create Date: 10/07/2019
-- Description: Update History Table with the Current Processed File and Remove any
--              History that's existing for more than 6 weeks as Retention Policy
-- ====================================================================================
BEGIN TRY

DECLARE @vSQL NVARCHAR(MAX)
DECLARE @DateStamp VARCHAR(10)
DECLARE @LogID int
--DECLARE @Run_ID int

--SELECT @Run_ID= RunId FROM dbo.HMRC.Data_Staging

select @DateStamp =  CAST(CAST(YEAR(GETDATE()) AS VARCHAR)+RIGHT('0' + RTRIM(cast(MONTH(getdate()) as varchar)), 2) +RIGHT('0' +RTRIM(CAST(DAY(GETDATE()) AS VARCHAR)),2) as int)

/* Start Logging Execution */

  INSERT INTO HMRC.Log_Execution_Results
	  (
	    RunId
	   ,StepNo
	   ,StoredProcedureName
	   ,StartDateTime
	   ,Execution_Status
	  )
  SELECT 
        @Run_Id
	   ,'Step-6'
	   ,'HMRC_UpdateHistoryTable'
	   ,getdate()
	   ,0

   SELECT @LogID=MAX(LogId) FROM HMRC.Log_Execution_Results 
   WHERE StoredProcedureName='HMRC_UpdateHistoryTable'
     AND RunId=@Run_ID


/* Update History Table with Latest Processed File */


INSERT INTO [HMRC].[Data_StagingHistory]
           (
		    b.MDL_ID,
			[Created_Date] ,
            [Load_ID] ,
            [SourceFileName] ,
		    [pay_scheme_reference]
           ,[accounting_office_reference]
           ,[scheme_cessation_date]
           ,[submission_date]
           ,[submission_id]
           ,[payroll_year]
           ,[payroll_month]
           ,[levy_due_year_to_date]
           ,[ef]
           ,[ef_date_caclulated]
           ,[latest_ef]
           ,[latest_ef_date_calculated]
           ,[SourceFile_ID]
           ,[RunID]
           ,[Inserted_DateTime]
           ,[Inserted_By]
           ,[isValid]
           ,[InvalidReason]
		   )
     SELECT
	         isnull(b.MDL_ID, -999)
			,getdate() as CreatedDate
			,isnull (b.Load_ID, -999)
		    ,CASE WHEN b.SourceFileName is null
			   THEN (SELECT TOP 1 SourceFileName FROM HMRC.Log_RunId WHERE Run_ID = a.RunID)
			 ELSE b.SourceFileName
			 END AS SourceFileName
	        ,a.[pay_scheme_reference]
           ,a.[accounting_office_reference]
           ,a.[scheme_cessation_date]
           ,a.[submission_date]
           ,a.[submission_id]
           ,a.[payroll_year]
           ,a.[payroll_month]
           ,a.[levy_due_year_to_date]
           ,a.[ef]
           ,a.[ef_date_caclulated]
           ,a.[latest_ef]
           ,a.[latest_ef_date_calculated]
           ,a.[SourceFile_ID]
           ,a.[RunID]
           ,a.[Inserted_DateTime]
           ,a.[Inserted_By]
           ,a.[isValid]
           ,a.[InvalidReason]
	 FROM HMRC.Data_Staging a
     LEFT JOIN HMRC.MIData_Live b 
	 ON a.Submission_Id = b.Submission_Id




   /* Update Record Counts */

   INSERT INTO HMRC.Log_Record_Counts
   (LogId,RunId,SourceTableName,TargetTableName,SourceRecordCount,TargetRecordCount)
   SELECT @LogID
         ,@Run_Id
		 ,'HMRC.Data_Staging'
	     ,'HMRC.Data_StagingHistory'
		 ,(SELECT COUNT(*) FROM HMRC.Data_Staging WHERE RunID=@Run_ID)
         ,(SELECT COUNT(*) FROM  HMRC.Data_StagingHistory WHERE RunId = @Run_ID)	
  
						

 
 /* Remove History that is More than 6 weeks and Update Log Table*/

 Declare @ToDeleteRunId table
 (ToDeleteRID INT)

 INSERT INTO @ToDeleteRunId(ToDeleteRID)
 SELECT DISTINCT RunId 
   FROM  HMRC.Data_StagingHistory TPRHist
  WHERE Inserted_DateTime < @RetentionDate

 DELETE TPRHist
   FROM  HMRC.Data_StagingHistory TPRHist
  WHERE Inserted_DateTime < @RetentionDate

 UPDATE SFL
    SET FileRemovedFromHistory=1
   FROM HMRC.Log_RunId SFL
  WHERE SFL.Run_ID IN (SELECT ToDeleteRID FROM @ToDeleteRunId)


/* Update Source File List as Processed */

UPDATE sfl
   SET FileLoadedToHistory=1
  FROM HMRC.Log_RunId sfl
 WHERE Run_Id=@Run_ID
  

 

/* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE HMRC.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Finish'
 WHERE LogId=@LogID
   AND RunID=@Run_Id


END TRY

BEGIN CATCH

  IF @@TRANCOUNT > 0
  ROLLBACK TRAN
  
  DECLARE @ErrorId int

  INSERT INTO HMRC.Log_Error_Details
	  (UserName
	  ,ErrorNumber
	  ,ErrorState
	  ,ErrorSeverity
	  ,ErrorLine
	  ,ErrorProcedure
	  ,ErrorMessage
	  ,ErrorDateTime
	  ,Run_Id
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'HMRC_UpdateHistoryTable' AS ErrorProcedure,
	    ERROR_MESSAGE(),
	    GETDATE(),
		@Run_Id as RunId; 

  SELECT @ErrorId=MAX(ErrorId) FROM HMRC.Log_Error_Details

/* Update Log Execution Results as Fail if there is an Error*/

UPDATE HMRC.Log_Execution_Results
   SET Execution_Status=0
      ,EndDateTime=getdate()
	  ,ErrorId=@ErrorId
 WHERE LogId=@LogID
   AND RunID=@Run_Id

END CATCH
GO


