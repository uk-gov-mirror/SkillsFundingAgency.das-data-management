﻿CREATE TABLE Stg.RAA_Vacancies
(
  SourseSK INT IDENTITY(1,1) NOT NULL
 ,BinaryId NVARCHAR(256) 
 ,TypeCode NVARCHAR(256)
 ,EmployerAccountId NVARCHAR(256)
 ,VacancyReference NVARCHAR(256)
 ,VacancyStatus NVARCHAR(256)
 ,OwnerType NVARCHAR(256)
 ,SourceOrigin NVARCHAR(256)
 ,SourceType NVARCHAR(256)
 ,CreatedDateTimeStamp NVARCHAR(256)
 ,CreatedByUserID NVARCHAR(256)
 ,CreatedByUserName NVARCHAR(256)
 ,CreatedByUserEmail NVARCHAR(256)
 ,LastUpdatedTimeStamp NVARCHAR(256)
 ,LastUpdatedByUserId NVARCHAR(256)
 ,LastUpdatedByUserName NVARCHAR(256)
 ,LastUpdatedByUserEmail NVARCHAR(256)
 ,IsDeleted  NVARCHAR(256)
 ,DeletedDateTimeStamp NVARCHAR(256)
 ,ClosingDateTimeStamp NVARCHAR(256)
 ,DisabilityConfident NVARCHAR(256)
 ,EmployerAddressLine1 NVARCHAR(256)
 ,EmployerAddressLine2 NVARCHAR(256)
 ,EmployerPostCode NVARCHAR(256)
 ,EmployerLatitude NVARCHAR(256)
 ,EmployerLongitude NVARCHAR(256)
 ,EmployerName NVARCHAR(256)
 ,EmployerNameOption NVARCHAR(256)
 ,LegalEntityName NVARCHAR(256)
 ,GeoCodeMethod NVARCHAR(256)
 ,LegalEntityId NVARCHAR(256)
 ,NumberOfPositions NVARCHAR(256)
 ,ProgrammeId NVARCHAR(256)
 ,ShortDescription NVARCHAR(256)
 ,StartDateTimeStamp NVARCHAR(256)
 ,VacancyTitle NVARCHAR(256)
 ,WageDuration NVARCHAR(256)
 ,WageDurationUnit NVARCHAR(256)
 ,WorkingWeekDescription NVARCHAR(256)
 ,WeeklyHours NVARCHAR(256)
 ,WageType NVARCHAR(256)
 ,RunId bigint  default(-1)
 ,AsDm_CreatedDate datetime2 default(getdate()) 
 ,AsDm_UpdatedDate datetime2 default(getdatE())
 )
