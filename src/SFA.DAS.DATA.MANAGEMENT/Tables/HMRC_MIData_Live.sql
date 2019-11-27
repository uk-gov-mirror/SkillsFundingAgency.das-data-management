
CREATE TABLE [HMRC].[MIData_Live](
	[MDL_ID] [int] IDENTITY(1,1) NOT NULL,
	[Created_Date] [datetime] NOT NULL,
	[Updated_Date] [datetime] NULL,
	[Delta_Action] [varchar](10) NULL,
	[Load_ID] [int] NULL,
	[SourceFileName] [varchar](256) NULL,
	[Paye_Scheme_Reference] [varchar](14) NULL,
	[Accounting_Office_Reference] [varchar](13) NULL,
	[Scheme_Cessation_Date] [date] NULL,
	[Submission_Date] [date] NULL,
	[Submission_ID] [int] NULL,
	[Payroll_Year] [varchar](5) NULL,
	[Payroll_Month] [int] NULL,
	[Levy_Due_Year_To_Date] [decimal](38, 6) NULL,
	[EnglishFraction] [decimal](38, 6) NULL,
	[Ef_Date_Calculated] [date] NULL,
	[Latest_EnglishFraction] [decimal](38, 6) NULL,
	[Latest_Ef_Date_Calculated] [date] NULL,
 CONSTRAINT [PK_MI_MDL_ID] PRIMARY KEY CLUSTERED 
(
	[MDL_ID] ASC
) 
) 
GO

ALTER TABLE [HMRC].[MIData_Live] ADD  DEFAULT (getdate()) FOR [Created_Date]
GO

ALTER TABLE [HMRC].[MIData_Live] ADD  DEFAULT (getdate()) FOR [Updated_Date]
GO

CREATE INDEX idx_MIData_Live_Submission_ID on [HMRC].[MIData_Live](Submission_ID)
