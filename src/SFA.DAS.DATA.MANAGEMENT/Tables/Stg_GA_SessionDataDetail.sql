﻿CREATE TABLE [Stg].[GA_SessionDataDetail]
(
		[GASD_Id] BIGINT IDENTITY(1,1)					NOT NULL,
		[FullVisitorId]									[NVarchar](500) NULL,
		[ClientId]										[NVarchar](500) NULL,			
		[VisitId]										[NVarchar](500) NULL,
		[VisitNumber]									[NVarchar](500) NULL,
		[VisitStartDateTime]							[NVarchar](500) NULL,
		[VisitDate]										[NVarchar](500) NULL,
		[VisitorId]										[NVarchar](500) NULL,
		[UserId]										[NVarchar](500) NULL,			
		[Hits_Page_PagePath]							[NVarchar](Max) NULL,		
		[Hits_Page_PagePathLevel1]						[NVarchar](Max) NULL,		
		[Hits_Page_PagePathLevel2]						[NVarchar](Max) NULL,		
		[Hits_Page_PagePathLevel3]						[NVarchar](Max) NULL,		
		[Hits_Page_PagePathLevel4]						[NVarchar](Max) NULL,		
		[Hits_Time]										[NVarchar](500) NULL,		
		[Hits_IsEntrance]								[NVarchar](500) NULL,
		[Hits_IsExit]									[NVarchar](500) NULL,		
		[EmployerId]									[NVarchar](500) NULL,
		[ID2]											[NVarchar](500) NULL,
		[ID3]											[NVarchar](500) NULL,
		[ESFAToken]										[NVarchar](500) NULL,		
		[EventCategory]									[NVarchar](max) NULL,
		[EventAction]									[NVarchar](max) NULL,
		[EventLabel]									[NVarchar](max) NULL,
		[EventLabel_ESFAToken]							[NVarchar](500) NULL,		
		[EventLabel_Keyword]							[NVarchar](2000) NULL,
		[EventLabel_Postcode]							[NVarchar](500) NULL,
		[EventLabel_WithinDistance]						[NVarchar](500) NULL,
		[EventLabel_Level]								[NVarchar](500) NULL,
		[EventValue]									[NVarchar](Max) NULL,
		[CD_ClientId]									[NVarchar](500) NULL, 
		[CD_SearchTerms]								[NVarchar](2000) NULL, 
		[CD_UserId]										[NVarchar](500) NULL, 
		[CD_LevyFlag]									[NVarchar](500) NULL, 
		[CD_EmployerId]									[NVarchar](500) NULL, 
		[CD_ESFAToken]									[NVarchar](500) NULL, 
		[CD_LegalEntityId]								[NVarchar](500) NULL,		
		[FileName]										[Nvarchar](500) NULL,
		[StgImportDate]									[datetime2](7) DEFAULT (getdate()),
		[Hits_Page_Hostname]							[NVarchar](500) NULL
)
GO
CREATE NONCLUSTERED INDEX NCI_GA_SessionDataDetail_StgImportDate  ON [Stg].[GA_SessionDataDetail] (StgImportDate ASC);
GO
CREATE NONCLUSTERED INDEX NCI_GA_SessionDataDetail_clientId  ON [Stg].[GA_SessionDataDetail] (ClientId ASC);
GO

