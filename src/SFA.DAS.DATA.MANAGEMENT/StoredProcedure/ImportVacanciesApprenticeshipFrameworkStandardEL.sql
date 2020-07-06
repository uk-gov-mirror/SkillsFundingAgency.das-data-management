﻿CREATE PROCEDURE [dbo].[ImportVacanciesApprenticeshipFrameworkStandardELToPL]
(
   @RunId int
)
AS
-- ===============================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 02/07/2020
-- Description: Import Vacancies Employer Data from v1 and v2
-- ===============================================================================

BEGIN TRY

DECLARE @LogID int
DEClARE @quote varchar(5) = ''''

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
	   ,'Step-6'
	   ,'ImportVacanciesApprenticeshipFrameworkStandardELToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVacanciesApprenticeshipFrameworkStandardELToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

DELETE FROM ASData_PL.Va_ApprenticeshipFrameWorkAndOccupation
DELETE FROM AsData_PL.Va_ApprenticeshipStandard
DELETE FROM AsData_PL.Va_EducationLevel

/* Load Framework into Presentation Layer */

INSERT INTO [ASData_PL].[Va_ApprenticeshipFrameWorkAndOccupation]
           ([SourceApprenticeshipFrameworkId]
           ,[ProgrammeId_v2]
           ,[SourceDb]
           ,[ApprenticeshipOccupationId]
           ,[FrameworkCodeName]
           ,[FrameworkShortName]
           ,[FrameWorkFullName]
           ,[FrameworkTitle_v2]
           ,[ApprenticeshipFrameworkStatus]
           ,[FrameworkClosedDate]
           ,[PreviousApprenticeshipOccupationId]
           ,[StandardId]
           ,[ApprenticeshipOccupationCodeName]
           ,[ApprenticeshipOccupationShortName]
           ,[ApprenticehipOccupationFullName]
           ,[ApprenticeshipOccupationStatus]
           ,[ApprenticeshipOccupationClosedDate])
SELECT AF.ApprenticeshipFrameworkId
      ,''
	  ,'RAAv1'
	  ,AO.ApprenticeshipOccupationId
	  ,AF.CodeName as FrameworkCodeName
	  ,AF.ShortName as FrameworkShortName
	  ,AO.FullName as FrameworkFullName
	  ,''
	  ,AFST.ShortName as FrameworkStatus
	  ,AF.ClosedDate
	  ,AF.PreviousApprenticeshipOccupationId
	  ,AF.StandardId
	  ,AO.Codename as ApprenticeshipOccupationCodeName
	  ,AO.ShortName as ApprenticeshipOccupationShortName
	  ,AO.FullName as ApprenticeshipOccupationFullName
	  ,AOST.FullName as ApprenticeshipOccupationStatus
	  ,AO.ClosedDate
  FROM Stg.Avms_ApprenticeshipFramework AF 
  JOIN Stg.Avms_ApprenticeshipOccupation AO 
    ON AO.ApprenticeshipOccupationId=AF.ApprenticeshipOccupationId
  LEFT
  JOIN Stg.Avms_ApprenticeshipFrameworkStatusType AFST
    ON AFST.ApprenticeshipFrameworkStatusTypeId=AF.ApprenticeshipFrameworkStatusTypeId
  LEFT
  JOIN Stg.Avms_ApprenticeshipOccupationStatusType AOST
    ON AOST.ApprenticeshipOccupationStatusTypeId=AO.ApprenticeshipOccupationStatusTypeId
 UNION
SELECT ap.SourseSK
      ,ap.ProgrammeId
	  ,'RAAv2'
	  ,AO.ApprenticeshipOccupationId
	  ,AF.CodeName as FrameworkCodeName
	  ,AF.ShortName as FrameworkShortName
	  ,AO.FullName as FrameworkFullName
	  ,ap.Title as FrameworkTitle
	  ,AFST.ShortName as FrameworkStatus
	  ,AF.ClosedDate
	  ,AF.PreviousApprenticeshipOccupationId
	  ,AF.StandardId
	  ,AO.Codename as ApprenticeshipOccupationCodeName
	  ,AO.ShortName as ApprenticeshipOccupationShortName
	  ,AO.FullName as ApprenticeshipOccupationFullName
	  ,AOST.FullName as ApprenticeshipOccupationStatus
	  ,AO.ClosedDate
  FROM Stg.RAA_ReferenceDataApprenticeshipProgrammes AP
  LEFT
  JOIN Stg.Avms_ApprenticeshipFramework AF 
    ON AF.CodeName=SUBSTRING(AP.ProgrammeId,1,3)
   AND AP.ApprenticeshipType='Framework'
  JOIN Stg.Avms_ApprenticeshipOccupation AO 
    ON AO.ApprenticeshipOccupationId=AF.ApprenticeshipOccupationId
  LEFT
  JOIN Stg.Avms_ApprenticeshipFrameworkStatusType AFST
    ON AFST.ApprenticeshipFrameworkStatusTypeId=AF.ApprenticeshipFrameworkStatusTypeId
  LEFT
  JOIN Stg.Avms_ApprenticeshipOccupationStatusType AOST
    ON AOST.ApprenticeshipOccupationStatusTypeId=AO.ApprenticeshipOccupationStatusTypeId

/* Load Standard Into Presentation Layer */

INSERT INTO [ASData_PL].[Va_ApprenticeshipStandard]
           ([StandardId]
           ,[LarsCode]
           ,[StandardFullName]
           ,[StandardSectorId]
           ,[StandardSectorName]
           ,[LarsStandardSectorCode]
           ,[ApprenticeshipOccupationId]
           ,[EducationLevelId]
           ,[ApprenticeshipFrameworkStatusType])
SELECT  ST.StandardId 
       ,ST.LarsCode as STLarsCode
       ,ST.FullName as SSFullName 
	   ,ST.StandardSectorId
	   ,SS.FullName as STFullName
	   ,SS.[LarsStandardSectorCode]
	   ,SS.ApprenticeshipOccupationId
	   ,ST.EducationLevelId
	   ,AFST.FullName as ApprenticeshipFrameworkStatusType
  FROM Stg.Avms_Standard ST 
  JOIN Stg.Avms_StandardSector SS 
    ON ST.StandardSectorId=SS.StandardSectorId
  LEFT
  JOIN Stg.Avms_ApprenticeshipFrameworkStatusType AFST
    ON AFST.ApprenticeshipFrameworkStatusTypeId=ST.ApprenticeshipFrameworkStatusTypeId

/* Load Education Level Into Presentation Layer */

INSERT INTO [ASData_PL].[Va_EducationLevel]
           ([EducationLevelId]
           ,[EducationLevelCodeName]
           ,[EducationLevelShortName]
           ,[EducationLevelFullName])
SELECT EducationLevelId
      ,CodeName
	  ,ShortName
	  ,FullName
  FROM Stg.Avms_EducationLevel








COMMIT TRANSACTION



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
	    'ImportVacanciesApprenticeshipFrameworkStandardELToPL',
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