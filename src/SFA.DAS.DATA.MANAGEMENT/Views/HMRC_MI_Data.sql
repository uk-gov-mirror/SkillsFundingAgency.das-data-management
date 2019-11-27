CREATE VIEW [HMRC].[MI_Data]
	AS SELECT

	         MDL_ID,
            [Submission_ID]
           ,[Submission_Date]
           ,[Paye_Scheme_Reference]
           ,[Accounting_Office_Reference]
           ,[Scheme_Cessation_Date]
           ,[Payroll_Year]
           ,[Payroll_Month]
           ,[Levy_Due_Year_To_Date]
           ,[EnglishFraction]
           ,[Ef_Date_Calculated]
           ,[Latest_EnglishFraction]
           ,[Latest_Ef_Date_Calculated]
FROM  HMRC.MIData_Live
	
	
	
	