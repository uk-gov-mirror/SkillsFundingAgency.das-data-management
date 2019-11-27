/* Execute Stored Procedure */

  EXEC [dbo].[Build_AS_DataMart]


/* Grant Permissions to Roles */

-- Create roles

IF DATABASE_PRINCIPAL_ID('Developer') IS NULL
BEGIN
	CREATE ROLE [Developer]
END


IF DATABASE_PRINCIPAL_ID('DataAnalyst') IS NULL
BEGIN
	CREATE ROLE [DataAnalyst]
END


IF DATABASE_PRINCIPAL_ID('HMRC_Reader') IS NULL
BEGIN
	CREATE ROLE [HMRC_Reader]
END



 -- Set permissions on views to roles



GRANT SELECT ON SCHEMA :: Comt TO Developer

GRANT SELECT ON SCHEMA :: Acct To Developer

GRANT SELECT ON SCHEMA :: EAUser To Developer

GRANT SELECT ON SCHEMA :: Fin To Developer

GRANT SELECT ON SCHEMA :: Mgmt To Developer

GRANT SELECT ON SCHEMA :: Resv To Developer

GRANT SELECT ON SCHEMA :: HMRC To Developer



GRANT SELECT ON dbo.Apprentice To Developer

GRANT SELECT ON dbo.Apprenticeship To Developer

GRANT SELECT ON dbo.AssessmentOrganisation To Developer

GRANT SELECT ON dbo.Commitment To Developer

GRANT SELECT ON dbo.DataLockStatus To Developer

GRANT SELECT ON dbo.EmployerAccount To Developer

GRANT SELECT ON dbo.EmployerAccountLegalEntity To Developer

GRANT SELECT ON dbo.Provider To Developer

GRANT SELECT ON dbo.TrainingCourse To Developer

GRANT SELECT ON dbo.Transfers To Developer

GRANT SELECT ON dbo.[ReferenceData] To Developer

GRANT SELECT ON [dbo].[DASCalendarMonth] To Developer

GRANT SELECT ON [HMRC].[Data_Import] To Developer

GRANT SELECT ON [HMRC].[Data_Staging] To Developer

GRANT SELECT ON [HMRC].[Data_Staging_Rejected] To Developer

GRANT SELECT ON [HMRC].[Data_StagingHistory] To Developer

GRANT SELECT ON [HMRC].[Data_Validation_Rules] To Developer

GRANT SELECT ON [HMRC].[Log_Error_Details] To Developer

GRANT SELECT ON [HMRC].[Log_Execution_Results] To Developer

GRANT SELECT ON [HMRC].[Log_Record_Counts] To Developer

GRANT SELECT ON [HMRC].[Log_RunID] To Developer




IF EXISTS(select 1 from sys.views where name='Das_Commitments' and type='v')
GRANT SELECT ON Data_Pub.Das_Commitments TO Developer

IF EXISTS(select 1 from sys.views where name='Das_NonLevy' and type='v')
GRANT SELECT ON Data_Pub.Das_NonLevy TO Developer

IF EXISTS(select 1 from sys.views where name='Das_Payments' and type='v')
GRANT SELECT ON Data_Pub.Das_Payments TO Developer

IF EXISTS(select 1 from sys.views where name='Das_LevyDeclarations' and type='v')
GRANT SELECT ON Data_Pub.Das_LevyDeclarations TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_Employer_AccountTransactions' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_AccountTransactions TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_CalendarMonth' and type='v')
GRANT SELECT ON Data_Pub.DAS_CalendarMonth TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_Employer_Account_Transfers' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Account_Transfers TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_Employer_PayeSchemes' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_PayeSchemes TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_Employer_LegalEntities' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_LegalEntities TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_Employer_Accounts' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Accounts TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_Employer_Transfer_Relationship' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Transfer_Relationship TO Developer

IF EXISTS(select 1 from sys.views where name='Das_TransactionLine' and type='v')
GRANT SELECT ON Data_Pub.Das_TransactionLine TO Developer

IF EXISTS(select 1 from sys.views where name='MI_Data' and type='v')
  BEGIN
		GRANT SELECT ON  HMRC.MI_Data TO Developer
  END


if exists(select 1 from sys.views where name='Das_Commitments' and type='v')
GRANT SELECT ON Data_Pub.Das_Commitments TO DataAnalyst

if exists(select 1 from sys.views where name='Das_NonLevy' and type='v')
GRANT SELECT ON Data_Pub.Das_NonLevy TO DataAnalyst

--IF EXISTS(select 1 from sys.views where name='Das_Payments' and type='v')
--GRANT SELECT ON Data_Pub.Das_Payments TO DataAnalyst

IF EXISTS(select 1 from sys.views where name='Das_LevyDeclarations' and type='v')
GRANT SELECT ON Data_Pub.Das_LevyDeclarations TO DataAnalyst

IF EXISTS(select 1 from sys.views where name='DAS_Employer_AccountTransactions' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_AccountTransactions TO DataAnalyst

IF EXISTS(select 1 from sys.views where name='DAS_CalendarMonth' and type='v')
GRANT SELECT ON Data_Pub.DAS_CalendarMonth TO DataAnalyst

if exists(select 1 from sys.views where name='DAS_Employer_Account_Transfers' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Account_Transfers TO DataAnalyst

if exists(select 1 from sys.views where name='DAS_Employer_PayeSchemes' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_PayeSchemes TO DataAnalyst

if exists(select 1 from sys.views where name='DAS_Employer_LegalEntities' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_LegalEntities TO DataAnalyst

if exists(select 1 from sys.views where name='DAS_Employer_Accounts' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Accounts TO DataAnalyst

if exists(select 1 from sys.views where name='DAS_Employer_Transfer_Relationship' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Transfer_Relationship TO DataAnalyst



IF EXISTS(select 1 from sys.views where name='MI_Data' and type='v')
  BEGIN
		GRANT SELECT ON  HMRC.MI_Data TO Developer
		GRANT SELECT ON  HMRC.MI_Data TO HMRC_Reader

  END


-- Populate HMRC Validation Rules Data

IF OBJECT_ID('[HMRC].[Data_Validation_Rules]') is not null
BEGIN

        TRUNCATE TABLE [HMRC].[Data_Validation_Rules]

		SET IDENTITY_INSERT [HMRC].[Data_Validation_Rules] ON 

		INSERT [HMRC].[Data_Validation_Rules] ([ID], [ColumnName], [ColumnNullable], [ColumnType], [ColumnLength], [ColumnPrecision], [ColumnDefault], [ColumnPattern], [ColumnMinValue], [ColumnMaxValue], [RunChecks], [RunTextLengthChecks], [RunNumericChecks], [RunPatternMatchChecks], [RunValueRangeChecks], [RunDecimalPlacesCheck], [RunDateChecks], [RunFixedLengthChecks]) VALUES (1, N'payroll_year', 1, N'VARCHAR', 5, 0, N'', N'', 0, 0, 1, 1, 0, 0, 0, 0, 0, 0)

		INSERT [HMRC].[Data_Validation_Rules] ([ID], [ColumnName], [ColumnNullable], [ColumnType], [ColumnLength], [ColumnPrecision], [ColumnDefault], [ColumnPattern], [ColumnMinValue], [ColumnMaxValue], [RunChecks], [RunTextLengthChecks], [RunNumericChecks], [RunPatternMatchChecks], [RunValueRangeChecks], [RunDecimalPlacesCheck], [RunDateChecks], [RunFixedLengthChecks]) VALUES (2, N'payroll_month', 1, N'INT', 0, 0, N'', N'', 1, 12, 1, 0, 1, 0, 0, 0, 0, 0)
		
		INSERT [HMRC].[Data_Validation_Rules] ([ID], [ColumnName], [ColumnNullable], [ColumnType], [ColumnLength], [ColumnPrecision], [ColumnDefault], [ColumnPattern], [ColumnMinValue], [ColumnMaxValue], [RunChecks], [RunTextLengthChecks], [RunNumericChecks], [RunPatternMatchChecks], [RunValueRangeChecks], [RunDecimalPlacesCheck], [RunDateChecks], [RunFixedLengthChecks]) VALUES (3, N'pay_scheme_reference', 0, N'VARCHAR', 14, 0, N'', N'[0-9][0-9][0-9]/[A-Z]%', 0, 0, 1, 1, 0, 1, 0, 0, 0, 0)
		
		INSERT [HMRC].[Data_Validation_Rules] ([ID], [ColumnName], [ColumnNullable], [ColumnType], [ColumnLength], [ColumnPrecision], [ColumnDefault], [ColumnPattern], [ColumnMinValue], [ColumnMaxValue], [RunChecks], [RunTextLengthChecks], [RunNumericChecks], [RunPatternMatchChecks], [RunValueRangeChecks], [RunDecimalPlacesCheck], [RunDateChecks], [RunFixedLengthChecks]) VALUES (4, N'accounting_office_reference', 0, N'VARCHAR', 13, 0, N'', N'', 0, 0, 1, 1, 0, 0, 0, 0, 0, 1)
		
		INSERT [HMRC].[Data_Validation_Rules] ([ID], [ColumnName], [ColumnNullable], [ColumnType], [ColumnLength], [ColumnPrecision], [ColumnDefault], [ColumnPattern], [ColumnMinValue], [ColumnMaxValue], [RunChecks], [RunTextLengthChecks], [RunNumericChecks], [RunPatternMatchChecks], [RunValueRangeChecks], [RunDecimalPlacesCheck], [RunDateChecks], [RunFixedLengthChecks]) VALUES (5, N'levy_due_year_to_date', 1, N'DECIMAL', 18, 2, N'', N'', -99999999999, 999999999999, 1, 0, 1, 0, 0, 0, 0, 0)
		
		INSERT [HMRC].[Data_Validation_Rules] ([ID], [ColumnName], [ColumnNullable], [ColumnType], [ColumnLength], [ColumnPrecision], [ColumnDefault], [ColumnPattern], [ColumnMinValue], [ColumnMaxValue], [RunChecks], [RunTextLengthChecks], [RunNumericChecks], [RunPatternMatchChecks], [RunValueRangeChecks], [RunDecimalPlacesCheck], [RunDateChecks], [RunFixedLengthChecks]) VALUES (6, N'ef', 1, N'DECIMAL', 18, 5, N'', N'', 0, 1, 1, 0, 1, 0, 0, 0, 0, 0)
		
		INSERT [HMRC].[Data_Validation_Rules] ([ID], [ColumnName], [ColumnNullable], [ColumnType], [ColumnLength], [ColumnPrecision], [ColumnDefault], [ColumnPattern], [ColumnMinValue], [ColumnMaxValue], [RunChecks], [RunTextLengthChecks], [RunNumericChecks], [RunPatternMatchChecks], [RunValueRangeChecks], [RunDecimalPlacesCheck], [RunDateChecks], [RunFixedLengthChecks]) VALUES (7, N'scheme_cessation_date', 1, N'Date', 0, 0, N'', N'', 0, 0, 1, 0, 0, 0, 0, 0, 1, 0)
		
		INSERT [HMRC].[Data_Validation_Rules] ([ID], [ColumnName], [ColumnNullable], [ColumnType], [ColumnLength], [ColumnPrecision], [ColumnDefault], [ColumnPattern], [ColumnMinValue], [ColumnMaxValue], [RunChecks], [RunTextLengthChecks], [RunNumericChecks], [RunPatternMatchChecks], [RunValueRangeChecks], [RunDecimalPlacesCheck], [RunDateChecks], [RunFixedLengthChecks]) VALUES (8, N'ef_date_caclulated', 1, N'Date', 0, 0, N'', N'', 0, 0, 1, 0, 0, 0, 0, 0, 1, 0)
		
		INSERT [HMRC].[Data_Validation_Rules] ([ID], [ColumnName], [ColumnNullable], [ColumnType], [ColumnLength], [ColumnPrecision], [ColumnDefault], [ColumnPattern], [ColumnMinValue], [ColumnMaxValue], [RunChecks], [RunTextLengthChecks], [RunNumericChecks], [RunPatternMatchChecks], [RunValueRangeChecks], [RunDecimalPlacesCheck], [RunDateChecks], [RunFixedLengthChecks]) VALUES (9, N'latest_ef', 1, N'DECIMAL', 18, 5, N'', N'', 0, 1, 1, 0, 1, 0, 0, 0, 0, 0)
		
		INSERT [HMRC].[Data_Validation_Rules] ([ID], [ColumnName], [ColumnNullable], [ColumnType], [ColumnLength], [ColumnPrecision], [ColumnDefault], [ColumnPattern], [ColumnMinValue], [ColumnMaxValue], [RunChecks], [RunTextLengthChecks], [RunNumericChecks], [RunPatternMatchChecks], [RunValueRangeChecks], [RunDecimalPlacesCheck], [RunDateChecks], [RunFixedLengthChecks]) VALUES (10, N'latest_ef_date_calculated', 1, N'Date', 0, 0, N'', N'', 0, 0, 1, 0, 0, 0, 0, 0, 1, 0)
		
		INSERT [HMRC].[Data_Validation_Rules] ([ID], [ColumnName], [ColumnNullable], [ColumnType], [ColumnLength], [ColumnPrecision], [ColumnDefault], [ColumnPattern], [ColumnMinValue], [ColumnMaxValue], [RunChecks], [RunTextLengthChecks], [RunNumericChecks], [RunPatternMatchChecks], [RunValueRangeChecks], [RunDecimalPlacesCheck], [RunDateChecks], [RunFixedLengthChecks]) VALUES (11, N'submission_date', 1, N'Date', 0, 0, N'', N'', 0, 0, 1, 0, 0, 0, 0, 0, 1, 0)
		
		INSERT [HMRC].[Data_Validation_Rules] ([ID], [ColumnName], [ColumnNullable], [ColumnType], [ColumnLength], [ColumnPrecision], [ColumnDefault], [ColumnPattern], [ColumnMinValue], [ColumnMaxValue], [RunChecks], [RunTextLengthChecks], [RunNumericChecks], [RunPatternMatchChecks], [RunValueRangeChecks], [RunDecimalPlacesCheck], [RunDateChecks], [RunFixedLengthChecks]) VALUES (12, N'submission_id', 0, N'INT', 0, 0, N'', N'', -2147483648, 2147483647, 1, 0, 1, 0, 0, 0, 0, 0)
		
		SET IDENTITY_INSERT [HMRC].[Data_Validation_Rules] OFF

END
