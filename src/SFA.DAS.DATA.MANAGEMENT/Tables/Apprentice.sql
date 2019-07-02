﻿ CREATE TABLE dbo.Apprentice
  (
   ID int identity(1,1) primary key not null
  ,FirstName varchar(255)
  ,LastName varchar(255)
  ,ULN nvarchar(50)
  ,DateOfBirth datetime
  ,NINumber nvarchar(10)
  ,Data_Source varchar(255)
 -- ,Source_ApprenticeshipId int
  ,AsDm_CreatedDate datetime2 default(getdate()) not null
  ,AsDm_UpdatedDate datetime2 default(getdate()) not null
  )