﻿
CREATE TABLE [HMRC].[Log_Error_Details](
	[ErrorId] [bigint] IDENTITY(1,1) NOT NULL,
	[Run_Id] [bigint] NOT NULL,
	[UserName] [varchar](100) NULL,
	[ErrorNumber] [bigint] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorLine] [int] NULL,
	[ErrorProcedure] [varchar](max) NULL,
	[ErrorMessage] [varchar](max) NULL,
	[ErrorDateTime] [datetime2](7) NULL,
 CONSTRAINT [PK_HMRC_Log_Error_Details_ErrorID] PRIMARY KEY CLUSTERED 
(
	[ErrorId] ASC
)
) 
GO