﻿CREATE TABLE [AsData_PL].[Va_VacancyHistory]
(	
  VacancyHistoryId Int
 ,VacancyId BIGINT
 ,VacancyHistoryEventTypeId int
 ,VacancyHistoryEventTypeDesc Varchar(255)
 ,HistoryDate datetime
 ,Comment nvarchar(4000)
 ,Foreign Key (VacancyId) References [AsData_PL].[Va_Vacancy](VacancyId)
)