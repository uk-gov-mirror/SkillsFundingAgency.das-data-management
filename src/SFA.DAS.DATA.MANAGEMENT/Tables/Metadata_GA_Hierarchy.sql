﻿Create Table mtd.Metadata_GA_Hierarchy
(
Id int Identity(1,1) not null,
Feedback_Category varchar(100) not null,
Feedback_Action varchar(255) not null,
Hierarchy_Grouping varchar(10) null,
Hierarchy int not null,
CreatedDate datetime default(getdate())
)