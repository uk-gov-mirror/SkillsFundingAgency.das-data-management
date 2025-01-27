﻿CREATE TABLE [ASData_PL].[FAT2_StandardSector](
	[StandardUId]									[varchar](20)		NOT NULL,
	[IfateReferenceNumber]							[varchar](10)		NOT NULL,
	[LarsCode]										[int]				NULL,
	[Status]										[varchar](100)		NOT NULL,
	[EarliestStartDate]								[datetime]			NULL,
	[LatestStartDate]								[datetime]			NULL,
	[LatestEndDate]									[datetime]			NULL,
	[Title]											[varchar](1000)		NOT NULL,
	[Level]											[int]				NOT NULL,
	[TypicalDuration]								[int]				NOT NULL,
	[MaxFunding]									[int]				NOT NULL,
	[IntegratedDegree]								[varchar](100)		NULL,
	[VaApprenticeshipStandardId]					[int]				NULL,
	[OverviewOfRole]								[varchar](max)		NOT NULL,
	[RouteCode]										[int]				NOT NULL,
	[RouteId]										[int]				NOT NULL,
	[Route]											[varchar](500)		NOT NULL,
	[AssessmentPlanUrl]								[varchar](500)		NULL,
	[ApprovedForDelivery]							[datetime]			NULL,
	[TrailBlazerContact]							[varchar](200)		NULL,
	[EqaProviderName]								[varchar](200)		NULL,
	[EqaProviderContactName]						[varchar](200)		NULL,
	[EqaProviderContactEmail]						[varchar](200)		NULL,
	[EqaProviderWebLink]							[varchar](500)		NULL,
	[Keywords]										[varchar](max)		NULL,
	[TypicalJobTitles]								[varchar](max)		NULL,
	[StandardPageUrl]								[varchar](500)		NOT NULL,
	[Version]										[decimal](18, 1)	NULL,
	[RegulatedBody]									[varchar](1000)		NULL,
	[Skills]										[nvarchar](max)		NULL,
	[Knowledge]										[nvarchar](max)		NULL,
	[Behaviours]									[nvarchar](max)		NULL,
	[Duties]										[nvarchar](max)		NULL,
	[CoreAndOptions]								[bit]				NOT NULL,
	[IntegratedApprenticeship]						[bit]				NOT NULL,
	[Options]										[nvarchar](max)		NULL,
	[AsDm_UpdatedDateTime]							[datetime2](7)	DEFAULT (getdate())
)