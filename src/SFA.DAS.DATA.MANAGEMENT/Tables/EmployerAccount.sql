﻿CREATE TABLE dbo.EmployerAccount
( Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL
 ,EmpHashedId NCHAR(6)
 ,EmpPublicHashedId NCHAR(6)
 ,EmpName nvarchar(255)
 ,AccountCreatedDate datetime2
 ,AccountUpdatedDate datetime2
 ,Data_Source varchar(255)
 ,Source_AccountId int
 ,AsDm_CreatedDate datetime2 default(getdate())
 ,AsDm_UpdatedDate datetime2 default(getdate())
 )