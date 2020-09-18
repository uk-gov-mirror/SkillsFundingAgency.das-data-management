﻿CREATE TABLE [ASData_PL].[Comt_Apprenticeship]
(
	[Id] [bigint] NOT NULL,
	[CommitmentId] [bigint] NOT NULL,	
	[ULN] [nvarchar](50) NULL,
	[TrainingType] [int] NULL,
	[TrainingCode] [nvarchar](20) NULL,
	[TrainingName] [nvarchar](126) NULL,
	[Cost] [decimal](18, 0) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[AgreementStatus] [smallint] NOT NULL,
	[PaymentStatus] [smallint] NOT NULL,
	[DateOfBirth] [datetime] NULL,	
	[EmployerRef] [nvarchar](50) NULL,
	[ProviderRef] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NULL,
	[AgreedOn] [datetime] NULL,
	[PaymentOrder] [int] NULL,
	[StopDate] [date] NULL,
	[PauseDate] [date] NULL,
	[HasHadDataLockSuccess] [bit] NOT NULL,
	[PendingUpdateOriginator] [tinyint] NULL,
	[EPAOrgId] [char](7) NULL,
	[CloneOf] [bigint] NULL,
	[ReservationId] [uniqueidentifier] NULL,
	[IsApproved] [bit] NULL,
	[CompletionDate] [datetime] NULL,
	[ContinuationOfId] [bigint] NULL,
	[MadeRedundant] [bit] NULL,
	[OriginalStartDate] [datetime] NULL,
	[Age] [int] NULL
	CONSTRAINT PK_Comt_Apprenticeship_Id PRIMARY KEY CLUSTERED (Id)
) ON [PRIMARY]