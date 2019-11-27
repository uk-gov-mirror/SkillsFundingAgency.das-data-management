
CREATE PROCEDURE [dbo].[HMRC_GenerateRunId]
AS
-- =========================================================================
-- Author:     Robin Rai
-- Create Date: 26/11/2019
-- Description: Generates RunId which will be used for logging Execution
-- =========================================================================
BEGIN TRY

/* Generate Run Id by inserting startdatetime into Log_RunId */

DECLARE @RunID bigint
DECLARE @DateStamp VARCHAR(10)
DECLARE @LogID int
DECLARE @CurrentSourceFileID int
DECLARE @NextSourceFileID int


/* Start Logging Execution */


SELECT @CurrentSourceFileID = MAX(SourceFileID) FROM [HMRC].[Log_RunId]

SELECT @NextSourceFileID = isnull(@CurrentSourceFileID,0) + 1


INSERT INTO [HMRC].[Log_RunId]
(
 StartDateTime,
 SourceFileID,
 SourceFileName
)
SELECT GETDATE(),
@NextSourceFileID,
replace(convert(varchar,  GETDATE() ,102),'.','-')


SELECT @RunID=MAX(Run_Id) FROM [HMRC].[Log_RunId]

select @DateStamp =  CAST(CAST(YEAR(GETDATE()) AS VARCHAR)+RIGHT('0' + RTRIM(cast(MONTH(getdate()) as varchar)), 2) +RIGHT('0' +RTRIM(CAST(DAY(GETDATE()) AS VARCHAR)),2) as int)



  INSERT INTO HMRC.Log_Execution_Results
	  (
	    RunId
	   ,StepNo
	   ,StoredProcedureName
	   ,StartDateTime
	   ,EndDateTime
	   ,Execution_Status
	   ,FullJobStatus
	  )
  SELECT 
        @RunID
	   ,'Step-1'
	   ,'HMRC_GenerateRunId'
	   ,getdate()
	   ,getdate()
	   ,1
	   ,'Pending- Go To Step 2 Import Data From Import To Staging'



 
/* Return Generated Run Id as Output*/

RETURN (@RunID)

END TRY

BEGIN CATCH

  
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
	    'HMRC_GenerateRunId' AS ErrorProcedure,
	    ERROR_MESSAGE(),
	    GETDATE(),
		@RunID as RunId; 

  SELECT @ErrorId =MAX(ErrorId) FROM HMRC.Log_Error_Details

/* Update Log Execution Results as Fail if there is an Error*/

UPDATE HMRC.Log_Execution_Results
   SET Execution_Status=0
      ,EndDateTime=getdate()
	  ,ErrorId=@ErrorId
 WHERE LogId=@LogID
   AND RunID=@RunId




END CATCH

GO





