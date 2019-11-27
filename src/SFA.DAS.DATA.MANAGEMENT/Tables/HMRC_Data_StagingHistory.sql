CREATE TABLE [HMRC].[Data_StagingHistory](
	[Data_StagingHistory_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[MDL_ID] [int] NULL,
	[Created_Date] [datetime] NULL,
	[Load_ID] [int] NULL,
	[SourceFileName] [varchar](256) NULL,
	[pay_scheme_reference] [varchar](256) NULL,
	[accounting_office_reference] [varchar](256) NULL,
	[scheme_cessation_date] [varchar](256) NULL,
	[submission_date] [varchar](256) NULL,
	[submission_id] [varchar](256) NULL,
	[payroll_year] [varchar](256) NULL,
	[payroll_month] [varchar](256) NULL,
	[levy_due_year_to_date] [varchar](256) NULL,
	[ef] [varchar](256) NULL,
	[ef_date_caclulated] [varchar](256) NULL,
	[latest_ef] [varchar](256) NULL,
	[latest_ef_date_calculated] [varchar](256) NULL,
	[SourceFile_ID] [bigint] NULL,
	[RunID] [int] NULL,
	[Inserted_DateTime] [datetime] NULL,
	[Inserted_By] [varchar](255) NULL,
	[isValid] [int] NULL,
	[InvalidReason] [varchar](512) NULL,
 CONSTRAINT [PK_Data_StagingHistory] PRIMARY KEY CLUSTERED 
(
	[Data_StagingHistory_ID] ASC
)
) 

GO

CREATE INDEX idx_Data_StagingHistory_Submission_ID on [HMRC].[Data_StagingHistory](Submission_ID)
GO
CREATE INDEX idx_Data_StagingHistory_RunID on [HMRC].[Data_StagingHistory](RunID)

