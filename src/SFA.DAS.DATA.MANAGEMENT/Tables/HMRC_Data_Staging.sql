CREATE TABLE [HMRC].[Data_Staging]
(
	[Record_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[pay_scheme_reference] [varchar](256) NULL,
	[accounting_office_reference] [varchar](256) NULL,
	[scheme_cessation_date] [varchar](256) NULL,
	[submission_date] [varchar](256) NULL,
	[Submission_ID] [varchar](256) NULL,
	[payroll_year] [varchar](256) NULL,
	[payroll_month] [varchar](256) NULL,
	[levy_due_year_to_date] [varchar](256) NULL,
	[ef] [varchar](256) NULL,
	[ef_date_caclulated] [varchar](256) NULL,
	[latest_ef] [varchar](256) NULL,
	[latest_ef_date_calculated] [varchar](256) NULL,
	[SourceFile_ID] [bigint] NULL,
	 RunID int  null,
	[Inserted_DateTime] [datetime] NULL,
	[Inserted_By] [varchar](255) NULL,
	isValid int null,
	InvalidReason varchar(512) null, 
   
)

GO


ALTER TABLE [HMRC].[Data_Staging] ADD  DEFAULT ((1)) FOR [SourceFile_ID]
GO

ALTER TABLE [HMRC].[Data_Staging] ADD  DEFAULT (getdate()) FOR [Inserted_DateTime]
GO

ALTER TABLE [HMRC].[Data_Staging] ADD  DEFAULT (suser_sname()) FOR [Inserted_By]
GO

CREATE INDEX idx_Data_Staging_Submission_ID on [HMRC].[Data_Staging](Submission_ID)
GO
CREATE INDEX idx_Data_Staging_RunID on [HMRC].[Data_Staging](RunID)
GO
CREATE INDEX idx_Data_Staging_isValid on [HMRC].[Data_Staging](isValid)


