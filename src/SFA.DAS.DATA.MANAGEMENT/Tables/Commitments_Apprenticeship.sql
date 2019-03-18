﻿CREATE TABLE [Comt].[Apprenticeship]
(
	[Id] BIGINT NOT NULL PRIMARY KEY , 
    [CommitmentId] BIGINT NOT NULL, 
    [FirstName] NVARCHAR(100) MASKED WITH (FUNCTION='default()') NULL,
    [LastName] NVARCHAR(100) MASKED WITH (FUNCTION='default()') NULL, 
    [ULN] NVARCHAR(50) NULL, 
    [TrainingType] INT NULL, 
    [TrainingCode] NVARCHAR(20) NULL, 
    [TrainingName] NVARCHAR(126) NULL, 
    [Cost] DECIMAL NULL, 
    [StartDate] DATETIME NULL, 
    [EndDate] DATETIME NULL, 
    [AgreementStatus] SMALLINT NOT NULL DEFAULT 0, 
	[AgreementStatusDesc] varchar(255) null,
    [PaymentStatus] SMALLINT NOT NULL DEFAULT 0, 
	[PaymentStatusDesc] varchar(255) null,
    [DateOfBirth] DATETIME NULL, 
    [NINumber] NVARCHAR(10) NULL, 
    [EmployerRef] NVARCHAR(50) MASKED WITH (FUNCTION='default()') NULL, 
    [ProviderRef] NVARCHAR(50) NULL, 
    [CreatedOn] DATETIME NULL, 
    [AgreedOn] DATETIME NULL, 
    [PaymentOrder] INT NULL, 
    [StopDate] DATE NULL, 
    [PauseDate] DATE NULL, 
	[HasHadDataLockSuccess] BIT NOT NULL DEFAULT 0,
	[PendingUpdateOriginator] TINYINT NULL,
	[EPAOrgId] CHAR(7) NULL,
	[CloneOf] BIGINT NULL,
    [IsApproved] AS (CASE WHEN PaymentStatus > 0 THEN CAST(1 as bit) ELSE CAST(0 as bit) END) PERSISTED, 
	[AsDm_Created_Date] datetime default(getdate()),
	[AsDm_Updated_Date] datetime default(getdate()),
	[Load_Id] int,
    CONSTRAINT [FK_Apprenticeship_Commitments] FOREIGN KEY ([CommitmentId]) REFERENCES [Comt].[Commitment]([Id]),
	CONSTRAINT [FK_Apprenticeship_AO] FOREIGN KEY ([EPAOrgId]) REFERENCES [Comt].[AssessmentOrganisation]([EPAOrgId])
)
GO

CREATE NONCLUSTERED INDEX [IX_Apprenticeship_CommitmentId] ON [Comt].[Apprenticeship] ([CommitmentId]) INCLUDE ([AgreedOn], [AgreementStatus], [Cost], [CreatedOn], [DateOfBirth], [EmployerRef], [EndDate], [FirstName], [LastName], [NINumber], [PaymentOrder], [PaymentStatus], [ProviderRef], [StartDate], [TrainingCode], [TrainingName], [TrainingType], [ULN], [StopDate], [PauseDate], [HasHadDataLockSuccess], [PendingUpdateOriginator]) WITH (ONLINE = ON)
GO
CREATE NONCLUSTERED INDEX [IX_Apprenticeship_Uln_Statuses] ON [Comt].[Apprenticeship] ([ULN], [AgreementStatus], [PaymentStatus])
GO
CREATE NONCLUSTERED INDEX [IX_Apprenticeship_AgreedOn] ON [Comt].[Apprenticeship] ([AgreedOn]) INCLUDE ([CommitmentId], [PaymentStatus]) WITH (ONLINE = ON)
GO
CREATE NONCLUSTERED INDEX [IX_Apprenticeship_Uln_PaymentStatus] ON [Comt].[Apprenticeship] ([PaymentStatus], [ULN]) INCLUDE ([AgreedOn], [CommitmentId], [StartDate], [StopDate]) WITH (ONLINE = ON)
GO