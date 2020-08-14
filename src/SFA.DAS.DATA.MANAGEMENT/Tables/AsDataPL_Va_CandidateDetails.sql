﻿CREATE TABLE [AsData_PL].[Va_CandidateDetails]
(
	[CandidateDetailsId] BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY
   ,[CandidateId] BIGINT NOT NULL
   ,[CandidateEthnicCode] Varchar(25)
   ,[CandidateEthnicDesc] Varchar(256)
   ,[SourceDb] Varchar(256)
)