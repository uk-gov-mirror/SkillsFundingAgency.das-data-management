﻿CREATE TABLE [Stg].[GA_SessionData]
(
	[GASD_Id] BIGINT IDENTITY(1,1) NOT NULL,
	[FullVisitorId] [nvarchar](512) NULL,
	[VisitNumber] [nvarchar](512) NULL,
	[VisitId] [nvarchar](512) NULL,
	[VisitStartDateTime] [nvarchar](512) NULL,
	[VisitDate] [nvarchar](512) NULL,
	[VisitorId] [nvarchar](512) NULL,
	[UserId] [nvarchar](512) NULL,
	[ClientId] [nvarchar](512) NULL,
	[Hits_Page_PagePath] [nvarchar](512) NULL,
	[Hits_Time] [nvarchar](512) NULL,
	[EmployerID] [nvarchar](512) NULL,
	[ID2] [nvarchar](512) NULL,
	[MarketoGUID] [nvarchar](512) NULL,
	[EFSAToken] [nvarchar](512) NULL,
	[Hits_Page_PagePathLevel1] [nvarchar](512) NULL,
	[Hits_Page_PagePathLevel2] [nvarchar](512) NULL,
	[Hits_Page_PagePathLevel3] [nvarchar](512) NULL,
	[Hits_Page_PagePathLevel4] [nvarchar](512) NULL,
	[FileName] [nvarchar](512) NULL,
	[StgImportDate] [nvarchar] (255)
)