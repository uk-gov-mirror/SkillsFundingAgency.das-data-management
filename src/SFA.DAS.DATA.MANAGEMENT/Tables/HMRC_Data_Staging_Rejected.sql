CREATE TABLE [HMRC].[Data_Staging_Rejected](
	[Record_ID] [bigint] NULL,
	[RunId] [bigint] NULL,
	[ColumnName] [varchar](256) NULL,
	[TestName] [varchar](256) NULL,
	[ErrorMessage] [varchar](max) NULL
)
GO
