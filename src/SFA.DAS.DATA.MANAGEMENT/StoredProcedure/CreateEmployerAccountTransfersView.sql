﻿CREATE PROCEDURE [dbo].[CreateEmployerAccountTransfersView]
(
   @RunId int
)
AS
/*===========================================================================
Author:      Simon Heath
Create Date: 12/09/2019
Description: Create Views for EmployerAccountTransfers that mimics RDS view

Simon Heath 05/11/2019 ADM-863 Changed where RequiredPaymentId is sourced 
from to workaround production bug in MA where the source has it set as all 
zeroes. 

Future improvements from Hima's review: 
1) TransferId is not unique in DataManagement but it's unique on RDS - worth 
informing Data Science on this.
2) RequiredPaymentID in data management is actually PaymentId on DEDS which 
we don't currently have in source AS databases. We can change this once
DEDS has been staged.
=============================================================================*/

BEGIN TRY


DECLARE @LogID int

/* Start Logging Execution */

  INSERT INTO Mgmt.Log_Execution_Results
	  (
	    RunId
	   ,StepNo
	   ,StoredProcedureName
	   ,StartDateTime
	   ,Execution_Status
	  )
  SELECT 
        @RunId
	   ,'Step-4'
	   ,'CreateEmployerAccountTransfersView'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='CreateEmployerAccountTransfersView'
     AND RunId=@RunID


DECLARE @VSQL1 NVARCHAR(MAX)
DECLARE @VSQL2 VARCHAR(MAX)
DECLARE @VSQL3 VARCHAR(MAX)
DECLARE @VSQL4 VARCHAR(MAX)

SET @VSQL1='
if exists(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME=''DAS_Employer_Account_Transfers'')
Drop View Data_Pub.DAS_Employer_Account_Transfers
'
SET @VSQL2='
CREATE VIEW [Data_Pub].[DAS_Employer_Account_Transfers]	AS 
	SELECT
	  ISNULL(CAST(AT.Id AS bigint),-1)                               AS TransferId
	, ISNULL(CAST(AT.SenderAccountId AS bigint),-1)                  as SenderAccountId
	, ISNULL(CAST(AT.ReceiverAccountId AS bigint),-1)                as ReceiverAccountId
	, ISNULL(p.PaymentID,''00000000-0000-0000-0000-000000000000'')   AS RequiredPaymentId
	, ISNULL(CAST(A.ID AS bigint),-1)                                AS CommitmentId
	, CAST(p.Amount as decimal(18,5))                                as Amount
	, ISNULL(CAST(AT.Type as nvarchar(50)),''NA'')                   AS Type
	, ISNULL(CAST (p.PeriodEnd AS NVARCHAR(10)),''XXXX'')            AS CollectionPeriodName
	, ISNULL(AT.CreatedDate,''9999-12-31'')                          AS UpdateDateTime
	FROM Fin.Ext_Tbl_AccountTransfers AT
	INNER JOIN Comt.Ext_Tbl_Apprenticeship A 
	  ON AT.ApprenticeshipId = A.ID
	LEFT OUTER JOIN 
	( SELECT xp.PaymentID
	  , xp.ApprenticeshipId
		, xp.PeriodEnd
		, xp.Amount
	  FROM Fin.Ext_Tbl_Payment xp 
	  WHERE xp.Fundingsource = 5 
	) AS p ON at.ApprenticeshipId=p.ApprenticeshipId and at.periodend=p.periodend
'
-- SET @VSQL3='  ' 
-- SET @VSQL4='  ' 

EXEC SP_EXECUTESQL @VSQL1 -- run check to drop view if it exists. 
EXEC (@VSQL2) -- run sql to create view. 
-- +@VSQL3+@VSQL4) -- no 3 or 4 as small view. 

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunId=@RunId

 
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;

    DECLARE @ErrorId int

  INSERT INTO Mgmt.Log_Error_Details
	  (UserName
	  ,ErrorNumber
	  ,ErrorState
	  ,ErrorSeverity
	  ,ErrorLine
	  ,ErrorProcedure
	  ,ErrorMessage
	  ,ErrorDateTime
	  ,RunId
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'CreateEmployerAccountTransfersView',
	    ERROR_MESSAGE(),
	    GETDATE(),
		@RunId as RunId; 

  SELECT @ErrorId=MAX(ErrorId) FROM Mgmt.Log_Error_Details

/* Update Log Execution Results as Fail if there is an Error*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=0
      ,EndDateTime=getdate()
	  ,ErrorId=@ErrorId
 WHERE LogId=@LogID
   AND RunID=@RunId

  END CATCH

GO


		  

