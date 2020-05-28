﻿CREATE TABLE [Mtd].[SourceConfigForImport]
(
	[SCFI_Id] INT NOT NULL 
   ,SourceDatabaseName Varchar(256)
   ,SourceTableName Varchar(256)
   ,ColumnNamesToInclude Varchar(MAX)
   ,ColumnNamesToExclude Varchar(MAX)
   ,IsEnabled bit default(1)
   ,AddedDate DateTime2 default(getdate())
   ,UpdatedDate DateTime2
)
