


CREATE PROCEDURE [dbo].[HMRC_ProcessFile]

AS
-- ==========================================================
-- Author:      Robin Rai
-- Create Date: 22/11/2019
-- Description: Master Stored Proc that Imports Data From File
--              Executes ETL and Loads History Table
-- ==========================================================

/* Generate Run Id for Logging Execution */

DECLARE @RunId int
DECLARE @DataSource varchar(255)
DECLARE @RetentionDate datetime
DECLARE @SourceFileID int

SELECT @RetentionDate=DATEADD(MONTH, -3, GETDATE()) 


/* Generate Run Id */

EXEC @RunId= HMRC_GenerateRunId

SELECT @SourceFileID = SourceFileID
FROM HMRC.Log_RunId
WHERE Run_Id = @RunId

/* Import Data to Staging from File */

EXEC [dbo].[HMRC_ImportDataFromImportToStaging] @RunId, @SourceFileID

/* Validation Checks */



IF EXISTS (SELECT 1 FROM HMRC.Log_Execution_Results where StoredProcedureName='HMRC_ImportDataFromImportToStaging' and Execution_Status=1 and RunId=@RunId)
BEGIN 
   EXEC dbo.HMRC_RunValidationChecks @RunId
END
ELSE
BEGIN
   RAISERROR( 'Import Data To Staging Table Failed - Check Log Table For Errors',1,1)
END

/* Merge  Valid Records in staging Into Live */

  DECLARE @SourceFile varchar(255)

      -- SELECT @SourceFile = 'SourceFile_' + Convert(varchar,@SourceFileID)
  SELECT @SourceFile = SourceFileName FROM HMRC.Log_RunID
  WHERE Run_ID = @RunID


IF EXISTS (SELECT 1 FROM HMRC.Log_Execution_Results where StoredProcedureName='HMRC_RunValidationChecks' and Execution_Status=1 and RunId=@RunId)
BEGIN 
  
   EXEC dbo.HMRC_MergeDataStagingToLive @RunId,  @SourceFile
END
ELSE
BEGIN
   RAISERROR( 'Validation Checks Failed - Check Log Table For Errors',1,1)
END




--/* Update History Table with Processed File */

IF EXISTS ( SELECT * FROM HMRC.Log_Execution_Results where StoredProcedureName='HMRC_MergeDataStagingToLive' and Execution_Status=1 and RunId=@RunId)
BEGIN
    EXEC HMRC_UpdateHistoryTable @RunId, @RetentionDate
END 
ELSE 
BEGIN 
    RAISERROR( 'Merging Staging Data to Live Failed-Check Log Table For Errors',1,1)
END




/* Raise Error if Updating History Table Failed */


IF EXISTS (SELECT * FROM HMRC.Log_Execution_Results where StoredProcedureName='HMRC_UpdateHistoryTable' and Execution_Status<>1 and RunId=@RunId)
BEGIN
RAISERROR( 'Updating History Table Failed-Check Log Table For Errors',1,1)
END

/* If we are here then we have finished...trash the data import */

UPDATE [HMRC].[Log_RunId]
SET EndDateTime = getdate()
WHERE Run_Id = @RunId

TRUNCATE TABLE HMRC.Data_Import

GO


