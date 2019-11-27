




CREATE PROCEDURE [dbo].[HMRC_MergeDataStagingToLive]
    @RunId int,
	@SourceFileName varchar(256)
AS
BEGIN

    SET DATEFORMAT DMY

    DECLARE @logid int

	INSERT INTO HMRC.Log_Execution_Results
	  (
	    RunId
	   ,StepNo
	   ,StoredProcedureName
	   ,StartDateTime
	   ,EndDateTime
	   ,Execution_Status
	   ,FullJobStatus
	  )
  SELECT 
        @RunId
	   ,'Step-5'
	   ,'HMRC_MergeDataStagingToLive'
	   ,getdate()
	   ,getdate()
	   ,1
	   ,'Pending- Go To Step 5  Update History'

   SET @LogID = SCOPE_IDENTITY()


	BEGIN TRY
	  
		DECLARE @LoadId INT

		--set @SourceFileName='delta'

		SET @LoadId=CAST(CAST(YEAR(GETDATE()) AS VARCHAR)+RIGHT('0' + RTRIM(cast(MONTH(getdate()) as varchar)), 2) +RIGHT('0' +RTRIM(CAST(DAY(GETDATE()) AS VARCHAR)),2) as int)
		print @loadid
	/* Merge Live with Data in Staging */



   BEGIN TRANSACTION

   MERGE  [HMRC].[MIData_Live] AS Target
   USING (
   
			 SELECT 
			 CAST(LTRIM(RTRIM(Pay_Scheme_Reference)) as Varchar(14)) as Paye_Scheme_Reference
			,CAST(LTRIM(RTRIM(Accounting_Office_Reference)) as Varchar(13)) as Accounting_Office_Reference

		--	,CONVERT(VARCHAR,LTRIM(RTRIM(Scheme_Cessation_Date)),23) as Scheme_Cessation_Date
		   ,CASE  WHEN isdate(Scheme_Cessation_Date ) = 1
				    THEN Convert(Date,Scheme_Cessation_Date)
			 ELSE null
			 END AS Scheme_Cessation_Date


			,convert(varchar,(LTRIM(RTRIM(Submission_Date))),23) as Submission_Date
			,CAST(LTRIM(RTRIM(Submission_Id)) as Int) as Submission_Id
			,CAST(LTRIM(RTRIM(Payroll_Year)) as Varchar(5)) as Payroll_Year
			,CAST(LTRIM(RTRIM(Payroll_Month)) as Int) as Payroll_Month
			,CAST(LTRIM(RTRIM(Levy_Due_Year_To_Date)) as Decimal(38,6)) as Levy_Due_Year_To_Date
    		,CAST(LTRIM(RTRIM(CASE WHEN ef='' THEN NULL ELSE ef end)) as Decimal(38,6)) as EnglishFraction

		--	,CAST(LTRIM(RTRIM(ef_date_caclulated)) as Date) as EF_Date_Calculated
		    ,CASE  WHEN isdate(ef_date_caclulated ) = 1
				    THEN Convert(Date,ef_date_caclulated)
			 ELSE null
			 END AS EF_Date_Calculated
		 
     		,CAST(LTRIM(RTRIM(CASE WHEN Latest_ef = ''
			                       THEN NULL 
							  ELSE Latest_ef
							  END )) as Decimal(38,6)) as Latest_EnglishFraction

		--	,convert(varchar,LTRIM(RTRIM(Latest_Ef_Date_Calculated)),23) as Latest_Ef_Date_Calculated
		    ,CASE  WHEN isdate(Latest_Ef_Date_Calculated ) = 1
				    THEN Convert(Date,Latest_Ef_Date_Calculated)
			 ELSE null
			 END AS Latest_Ef_Date_Calculated
			 FROM HMRC.Data_Staging
			 WHERE isnull(IsValid,1) = 1

		  ) As Source
      ON (Target.Submission_Id = Source.Submission_Id)
    WHEN matched AND (ISNULL(SOURCE.PAYE_SCHEME_REFERENCE,'n/a')<>ISNULL(TARGET.PAYE_SCHEME_REFERENCE,'n/a')
	                OR ISNULL(SOURCE.Accounting_Office_Reference,'n/a')<>ISNULL(TARGET.Accounting_Office_Reference,'n/a')
					OR ISNULL(SOURCE.Scheme_Cessation_Date,'9999-12-31')<>ISNULL(Target.Scheme_Cessation_Date,'9999-12-31')
					OR ISNULL(Source.Submission_Date,'9999-12-31')<>ISNULL(Target.Submission_Date,'9999-12-31')
					OR ISNULL(Source.Payroll_Year,'n/a')<>ISNULL(Target.Payroll_Year,'n/a')
					OR ISNULL(Source.Payroll_Month,-1)<>ISNULL(Target.Payroll_Month,-1)
					OR ISNULL(Source.Levy_Due_Year_To_Date,-1)<>ISNULL(Target.Levy_Due_Year_To_Date,-1)
					OR ISNULL(Source.EnglishFraction,-1)<>ISNULL(Target.EnglishFraction,-1)
					OR ISNULL(Source.EF_Date_Calculated,'9999-12-31')<>ISNULL(Target.EF_Date_Calculated,'9999-12-31')
					OR ISNULL(Source.Latest_EnglishFraction,-1)<>ISNULL(Target.Latest_EnglishFraction,-1)
					OR ISNULL(Source.Latest_EF_Date_Calculated,'9999-12-31')<>ISNULL(Target.Latest_EF_Date_Calculated,'9999-12-31'))
					THEN 
  UPDATE SET
         Paye_Scheme_Reference=Source.Paye_Scheme_Reference
		,Accounting_Office_Reference=Source.Accounting_Office_Reference
		,Scheme_Cessation_Date=Source.Scheme_Cessation_Date
		,Submission_Date=Source.Submission_Date
		,Payroll_Year=Source.Payroll_Year
		,Payroll_Month=Source.Payroll_Month
		,Levy_Due_Year_To_Date=Source.Levy_Due_Year_To_Date
		,EnglishFraction=Source.EnglishFraction
		,EF_Date_Calculated=Source.EF_Date_Calculated
		,Latest_EnglishFraction=Source.Latest_EnglishFraction
		,Latest_EF_Date_Calculated=Source.Latest_EF_Date_Calculated
		,Delta_Action='Update'
		,Updated_Date=getdate()
		,SourceFileName=@SourceFileName
		,Load_ID=@LoadId
	WHEN NOT MATCHED BY TARGET THEN
   INSERT (
            [Created_Date]
           ,[Updated_Date]
           ,[Load_ID]
           ,[Paye_Scheme_Reference]
           ,[Accounting_Office_Reference]
           ,[Scheme_Cessation_Date]
           ,[Submission_Date]
           ,[Submission_Id]
           ,[Payroll_Year]
           ,[Payroll_Month]
           ,[Levy_Due_Year_To_Date]
           ,[EnglishFraction]
           ,[Ef_Date_Calculated]
           ,[Latest_EnglishFraction]
           ,[Latest_Ef_Date_Calculated]
		   ,SourceFileName
		   ,Delta_Action
		   )
    VALUES (
	        getdate()
	      , null
		  , @LoadId
		  , Source.[Paye_Scheme_Reference]
          , Source.[Accounting_Office_Reference]
          , Source.[Scheme_Cessation_Date]
           ,Source.[Submission_Date]
           ,Source.[Submission_Id]
           ,Source.[Payroll_Year]
           ,Source.[Payroll_Month]
           ,Source.[Levy_Due_Year_To_Date]
           ,Source.[EnglishFraction]
           ,Source.[Ef_Date_Calculated]
           ,Source.[Latest_EnglishFraction]
           ,Source.[Latest_Ef_Date_Calculated]
		  , @SourceFileName
		  ,'Insert'
		   );


		

  UPDATE HMRC.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
    WHERE LogId=@LogID
   AND RunID=@RunID

   
	
END TRY
BEGIN CATCH

   IF @@TRANCOUNT > 0
   BEGIN
        ROLLBACK TRANSACTION
   END

DECLARE @ErrorId int

  INSERT INTO HMRC.Log_Error_Details
	  (UserName
	  ,ErrorNumber
	  ,ErrorState
	  ,ErrorSeverity
	  ,ErrorLine
	  ,ErrorProcedure
	  ,ErrorMessage
	  ,ErrorDateTime
	  ,Run_Id
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'HMRC_MergeDataStagingToLive' AS ErrorProcedure,
	    ERROR_MESSAGE(),
	    GETDATE(),
		@RunID as RunId; 

  SELECT @ErrorId =MAX(ErrorId) FROM HMRC.Log_Error_Details

/* Update Log Execution Results as Fail if there is an Error*/

UPDATE HMRC.Log_Execution_Results
   SET Execution_Status= 0
      ,EndDateTime=getdate()
	  ,ErrorId=@ErrorId
 WHERE LogId=@LogID
   AND RunID=@RunID


END CATCH

IF @@TRANCOUNT > 0
BEGIN
   COMMIT TRANSACTION	
END



END


GO