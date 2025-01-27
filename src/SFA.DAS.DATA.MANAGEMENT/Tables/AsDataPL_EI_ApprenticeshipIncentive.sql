﻿CREATE TABLE [AsData_PL].[EI_ApprenticeshipIncentive]
(
   ID													UniqueIdentifier Primary Key	Not Null
  ,AccountId											bigint							not null
  ,ApprenticeshipId										bigint							not null
  ,EmployerType											int								not null
  ,IncentiveApplicationApprenticeshipId					uniqueidentifier				not null 
  ,AccountLegalEntityId									bigint							null
  ,UKPRN												bigint							NULL
  ,RefreshedLearnerForEarnings							bit								NULL
  ,HasPossibleChangeOfCircumstances						bit								NULL
  ,PausePayments										bit								NULL
  ,StartDate											datetime2(7)					NULL
  ,SubmittedDate										datetime2(7)					NULL
  ,CourseName											nvarchar(200)					NULL
  ,[Status]												nvarchar(50)					NULL
  ,AsDm_UpdatedDateTime									datetime2						default getdate()
)
