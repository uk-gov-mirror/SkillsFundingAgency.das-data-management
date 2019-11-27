
CREATE TABLE [HMRC].[Log_Execution_Results](
	[LogId] [bigint] IDENTITY(1,1) NOT NULL,
	[RunId] [bigint] NOT NULL,
	[ErrorId] [bigint] NULL,
	[StepNo] [varchar](100) NULL,
	[StoredProcedureName] [varchar](100) NOT NULL,
	[Execution_Status] [bit] NOT NULL,
	[Execution_Status_Desc]  AS (case when [Execution_Status]=(1) then 'Success' else 'Fail' end),
	[StartDateTime] [datetime2](7) NULL,
	[EndDateTime] [datetime2](7) NULL,
	[FullJobStatus] [varchar](256) NULL,
 CONSTRAINT [PK_HMRC_Log_Execution_Results_LogID] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)
) 
GO

CREATE INDEX idx_Log_Execution_Results_RunId ON [HMRC].[Log_Execution_Results](runID)
GO
CREATE INDEX idx_Log_Execution_Results_LogID ON [HMRC].[Log_Execution_Results](logID)
GO


