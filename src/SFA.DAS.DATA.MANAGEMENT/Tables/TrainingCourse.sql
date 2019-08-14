﻿
  CREATE TABLE dbo.TrainingCourse
  (ID int identity(1,1) not null
  ,TrainingType bit
  ,TrainingCode varchar(20)
  ,TrainingName nvarchar(255)
  ,Data_Source varchar(255)
  ,Source_ApprenticeshipId int
  ,RunId bigint default(-1)
  ,AsDm_CreatedDate datetime2 default(getdate()) not null
  ,AsDm_UpdatedDate datetime2 default(getdate()) not null
  ,CONSTRAINT PK_TrainingCourse_ID PRIMARY KEY(ID)
  )
