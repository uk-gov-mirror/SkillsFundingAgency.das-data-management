
CREATE PROCEDURE [dbo].[HMRC_ImportDataFromImportToStaging]
	@RunID int,
	@SourceFileID int

AS
BEGIN


-- =============================================
-- Author:		Robin Rai
-- Create date: 2511/2019
-- Description:	Imports Data from import into staging
-- =============================================




    DECLARE @LogID int

	BEGIN TRY

	--DECLARE @runid int = 1

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
        @RunId
	   ,'Step-2'
	   ,'HMRC_ImportDataFromImportToStaging'
	   ,getdate()
	   ,getdate()
	   ,1
	   ,'Pending- Go To Step 3 Run Validation Rules'

   SET @LogID = SCOPE_IDENTITY()

   DELETE HMRC.Data_Staging
   
   INSERT [HMRC].[Data_Staging]
           (
		   
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
		   , RunID
           
		   )
     SELECT
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
		   ,@SourceFileID
		   ,@RunID
	  FROM [HMRC].Data_Import

	  -- Cleanse for blank And Text 'NULL' in all columns which might be imported by format file

	  UPDATE HMRC.Data_Staging
	  SET [pay_scheme_reference] = null
	  WHERE ltrim(rtrim([pay_scheme_reference])) = '' OR  ltrim(rtrim([pay_scheme_reference])) = 'NULL'

      UPDATE HMRC.Data_Staging
	  SET [accounting_office_reference] = null
	  WHERE ltrim(rtrim([accounting_office_reference])) = '' OR  ltrim(rtrim([accounting_office_reference])) = 'NULL'
	  
      UPDATE HMRC.Data_Staging
	  SET [scheme_cessation_date] = null
	  WHERE ltrim(rtrim([scheme_cessation_date])) = '' OR  ltrim(rtrim([scheme_cessation_date])) = 'NULL'

	  UPDATE HMRC.Data_Staging
	  SET [submission_date] = null
	  WHERE ltrim(rtrim([submission_date])) = '' OR  ltrim(rtrim([submission_date])) = 'NULL'

      UPDATE HMRC.Data_Staging
	  SET [submission_id] = null
	  WHERE ltrim(rtrim([submission_id])) = '' OR  ltrim(rtrim([submission_id])) = 'NULL'

	  UPDATE HMRC.Data_Staging
	  SET [payroll_year] = null
	  WHERE ltrim(rtrim([payroll_year])) = '' OR  ltrim(rtrim([payroll_year])) = 'NULL'

	  UPDATE HMRC.Data_Staging
	  SET [payroll_month] = null
	  WHERE ltrim(rtrim([payroll_month])) = '' OR  ltrim(rtrim([payroll_month])) = 'NULL'

	  UPDATE HMRC.Data_Staging
	  SET [levy_due_year_to_date] = null
	  WHERE ltrim(rtrim([levy_due_year_to_date])) = '' OR  ltrim(rtrim([levy_due_year_to_date])) = 'NULL'


	  UPDATE HMRC.Data_Staging
	  SET [ef] = null
	  WHERE ltrim(rtrim([ef])) = '' OR  ltrim(rtrim([ef])) = 'NULL'


      UPDATE HMRC.Data_Staging
	  SET [ef_date_caclulated] = null
	  WHERE ltrim(rtrim([ef_date_caclulated])) = '' OR  ltrim(rtrim([ef_date_caclulated])) = 'NULL'

	  UPDATE HMRC.Data_Staging
	  SET [latest_ef] = null
	  WHERE ltrim(rtrim([latest_ef])) = '' OR  ltrim(rtrim([latest_ef])) = 'NULL'

	  UPDATE HMRC.Data_Staging
	  SET [latest_ef_date_calculated] = null
	  WHERE ltrim(rtrim([latest_ef_date_calculated])) = '' OR  ltrim(rtrim([latest_ef_date_calculated])) = 'NULL'

	 

	
  UPDATE HMRC.Log_Execution_Results
   SET Execution_Status=1
    --  ,Execution_Status_Desc = 'Success'
      ,EndDateTime=getdate()
    WHERE LogId=@LogID
   AND RunID=@RunID



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
	    'HMRC_ImportDataFromImportToStaging' AS ErrorProcedure,
	    ERROR_MESSAGE(),
	    GETDATE(),
		@RunID as RunId; 

  SELECT @ErrorId =MAX(ErrorId) FROM HMRC.Log_Error_Details

/* Update Log Execution Results as Fail if there is an Error*/

UPDATE HMRC.Log_Execution_Results
   SET Execution_Status= 0
      ,EndDateTime=getdate()
	  ,ErrorId=@ErrorId
 WHERE LogId=@LogID
   AND RunID=@RunID





  END CATCH
END

GO





