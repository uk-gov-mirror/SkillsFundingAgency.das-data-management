﻿CREATE TABLE [HMRC].[Data_Validation_Rules]
   (
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ColumnName] [varchar](255) NOT NULL,
	[ColumnNullable] [bit] NOT NULL,
	[ColumnType] [varchar](255) NOT NULL,
	[ColumnLength] [int] NULL,
	[ColumnPrecision] [int] NULL,
	[ColumnDefault] [varchar](255) NULL,
	[ColumnPattern] [varchar](255) NULL,
	[ColumnMinValue] [bigint] NULL,
	[ColumnMaxValue] [bigint] NULL,
	[RunChecks] [bit] NOT NULL,
	[RunTextLengthChecks] [bit] NOT NULL,
	[RunNumericChecks] [bit] NOT NULL,
	[RunPatternMatchChecks] [bit] NOT NULL,
	[RunValueRangeChecks] [bit] NOT NULL,
	[RunDecimalPlacesCheck] [bit] NOT NULL,
	[RunDateChecks] [bit] NOT NULL,
	[RunFixedLengthChecks] [bit] NULL,
 CONSTRAINT [PK_DVR_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)
) 
GO

CREATE INDEX idx_Data_Validation_Rules_ColumnType on [HMRC].[Data_Validation_Rules]([ColumnType])
