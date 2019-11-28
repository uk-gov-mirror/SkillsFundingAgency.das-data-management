

CREATE PROCEDURE [dbo].[HMRC_RunValidationChecks]
(@Run_Id bigint)
AS
-- ====================================================================================
-- Author:      R.Rai
-- Create Date: 20/11/2019
-- Description: Run Validation Checks before loading Main Tables to Flag Invalid Rows 
-- ====================================================================================

 BEGIN TRY

DECLARE @vSQL NVARCHAR(MAX)
DECLARE @DateStamp VARCHAR(10)
DECLARE @LogID int

SET DATEFORMAT DMY

/*
 DECLARE @Run_ID int  
 SELECT @Run_ID = Run_Id FROM HMRC.Log_RunID
 SELECT @Run_ID
*/

select @DateStamp =  CAST(CAST(YEAR(GETDATE()) AS VARCHAR)+RIGHT('0' + RTRIM(cast(MONTH(getdate()) as varchar)), 2) +RIGHT('0' +RTRIM(CAST(DAY(GETDATE()) AS VARCHAR)),2) as int)

/* Start Logging Execution */

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
        @Run_Id
	   ,'Step-3'
	   ,'HMRC_RunValidationChecks'
	   ,getdate()
	   ,getdate()
	   ,1
	   ,'Pending- Go To Step 4 Merge Staging into HMRC Live'

   SET @LogID = SCOPE_IDENTITY()

	--   DECLARE @LogID int

 -- SELECT @LogID=MAX(LogId) FROM HMRC.Log_Execution_Results

 -- SELECT @logiD


  /* Delete existing rejected rows for the same Run id */

  DELETE a
    FROM HMRC.Data_Staging_Rejected a
   WHERE a.RunId= @Run_ID

/* String Tests */

  DECLARE @ColumnName VARCHAR(255), @ColumnType VARCHAR(255), @ColumnLength INT, @TestName VARCHAR(255), @ErrorMessage VARCHAR(255), 
				@ColumnStopOnErrorFlag BIT, 
				@ColumnPrecision INT,
				@ColumnPatternMatching nvarchar(255),
				@Sql nvarchar(2000),
				@ColumnMinValue varchar(255), 
				@ColumnMaxValue varchar(255) 

			DECLARE StringTestConfig CURSOR FOR
			SELECT DVR.ColumnName
				,DVR.ColumnType
				, DVR.ColumnLength
				, 'String Length Test'
				, 'String length exceeds Specification.' AS ErrorMessage
			FROM HMRC.Data_Validation_Rules AS DVR
			WHERE DVR.ColumnType IN ('VARCHAR', 'NVARCHAR','CHAR','NCHAR')
			  AND RunChecks=1 and RunTextLengthChecks=1 

			OPEN StringTestConfig
			FETCH NEXT FROM StringTestConfig INTO
			@ColumnName, @ColumnType, @ColumnLength, @TestName, @ErrorMessage

			WHILE @@FETCH_STATUS = 0
			BEGIN
				   SET @SQL='
				   INSERT INTO HMRC.Data_Staging_Rejected
				  ( Record_ID ,RunId, ColumnName, TestName, ErrorMessage ) 
				   SELECT Record_ID,
				          RunID ,
     					'''+ @ColumnName + ''' AS ColumnName, 
						'''+ @TestName + ''' AS TestName,
						'''+ @ErrorMessage +' Actual: '' + CAST(LEN('+ @ColumnName + ')AS VARCHAR(255))+ '' Against spec size: '+CAST(@columnLength AS VARCHAR(255)) + ''' AS ErrorMessage
					FROM HMRC.Data_Staging
				   WHERE LEN(REPLACE('+ @ColumnName + ',''NULL'',''''))  >'+  CAST(@ColumnLength AS varchar(255)) +''
	   
	            PRINT @SQL
				EXEC (@SQL)
				

				

				FETCH NEXT FROM StringTestConfig INTO
				@ColumnName, @ColumnType, @ColumnLength, @TestName, @ErrorMessage
			END

			CLOSE StringTestConfig
			DEALLOCATE StringTestConfig


			
			

print ''
print 'STRING TESTS COMPLETE'
print ''


print ''
print 'STRING FIXED STRING LENGTH TESTS START'
print ''




/* String FixedLength Tests */

			DECLARE StringTestConfig CURSOR FOR
			SELECT DVR.ColumnName
				,DVR.ColumnType
				, DVR.ColumnLength
				, 'String Length Test'
				, 'String length fails Specification.' AS ErrorMessage
			FROM HMRC.Data_Validation_Rules AS DVR
			WHERE DVR.ColumnType IN ('VARCHAR', 'NVARCHAR','CHAR','NCHAR')
			  AND RunChecks=1 and RunTextLengthChecks=1 and RunFixedLengthChecks=1

			OPEN StringTestConfig
			FETCH NEXT FROM StringTestConfig INTO
			@ColumnName, @ColumnType, @ColumnLength, @TestName, @ErrorMessage

			WHILE @@FETCH_STATUS = 0
			BEGIN
				   SET @SQL='
				   INSERT INTO HMRC.Data_Staging_Rejected
				  ( Record_ID,RunId, ColumnName, TestName, ErrorMessage ) 
				   SELECT Record_ID,
				          RunID ,
     					'''+ @ColumnName + ''' AS ColumnName, 
						'''+ @TestName + ''' AS TestName,
						'''+ @ErrorMessage +' Actual: '' + CAST(LEN('+ @ColumnName + ')AS VARCHAR(255))+ '' Against spec size: '+CAST(@columnLength AS VARCHAR(255)) + ''' AS ErrorMessage
					FROM HMRC.Data_Staging
				   WHERE LEN(REPLACE('+ @ColumnName + ',''NULL'',''''))  <>'+  CAST(@ColumnLength AS varchar(255)) +''
	   
	         	PRINT @SQL
				EXEC (@SQL)
			

				


				FETCH NEXT FROM StringTestConfig INTO
				@ColumnName, @ColumnType, @ColumnLength, @TestName, @ErrorMessage
			END

			CLOSE StringTestConfig
			DEALLOCATE StringTestConfig

		
print ''
print 'STRING FIXED LENGTH TESTS COMPLETE'
print ''

		
print ''
print 'STRING NOT NULL TESTS START'
print ''


-- String not null tests

           SET @SQL=''

			DECLARE StringNotNullConfig CURSOR FOR
			SELECT DVR.ColumnName
				,DVR.ColumnType
				, DVR.ColumnLength
				, 'String Not Null Test'
				, 'String Not Null is null.' AS ErrorMessage
			FROM HMRC.Data_Validation_Rules AS DVR
			WHERE DVR.ColumnType IN ('VARCHAR', 'NVARCHAR','CHAR','NCHAR')
			  AND RunChecks=1 and RunTextLengthChecks=1 and ColumnNullable=0

			OPEN StringNotNullConfig
			FETCH NEXT FROM StringNotNullConfig INTO
			@ColumnName, @ColumnType, @ColumnLength, @TestName, @ErrorMessage

			WHILE @@FETCH_STATUS = 0
			BEGIN
				   SET @SQL='
				   INSERT INTO HMRC.Data_Staging_Rejected
				  ( Record_ID,RunId, ColumnName, TestName, ErrorMessage ) 
				   SELECT Record_ID,
				          RunID ,
						'''+ @ColumnName + ''' AS ColumnName, 
						'''+ @TestName + ''' AS TestName,
						'''+ @ErrorMessage +''' AS ErrorMessage
					FROM HMRC.Data_Staging
				   WHERE '+ @ColumnName + ' IS NULL
				      OR '+@ColumnName+'=''NULL''
	             '

				PRINT @SQL
				EXEC (@SQL)
			

				FETCH NEXT FROM StringNotNullConfig INTO
				@ColumnName, @ColumnType, @ColumnLength, @TestName, @ErrorMessage
			END

			CLOSE StringNotNullConfig
			DEALLOCATE StringNotNullConfig

print ''
print 'STRING not null tests COMPLETE'
print ''


print ''
print 'DECIMAL PLACES TEST START'
print ''



-- Decimal place test
            SET @SQL=''

			DECLARE DecimalPlacesTestConfig CURSOR FOR

			SELECT DVR.ColumnName
				,DVR.ColumnType
				, DVR.ColumnLength
				, 'Decimal Places Test'
				, 'Decimal places do not match specification.' AS ErrorMessage
				, DVR.ColumnPrecision
			FROM HMRC.Data_Validation_Rules AS DVR
		   WHERE ColumnType = 'DECIMAL'
		     AND RunChecks=1 and RunDecimalPlacesCheck=1

			OPEN DecimalPlacesTestConfig
			FETCH NEXT FROM DecimalPlacesTestConfig INTO 
			@ColumnName, @ColumnType, @ColumnLength, @TestName, @ErrorMessage, @ColumnPrecision

			WHILE @@FETCH_STATUS = 0
			BEGIN


				SET @SQL='
				INSERT INTO HMRC.Data_Staging_Rejected
				 ( Record_ID,RunId,ColumnName, TestName, ErrorMessage ) 
				 SELECT Record_ID,
				          RunID ,
					'''+ @ColumnName + ''' AS ColumnName, 
					'''+ @TestName + ''' AS TestName,
					'''+ @ErrorMessage +' Actual: ''+ CAST('+ @ColumnName +' AS VARCHAR(255)) +'' Expected Decimal Places: '+ CAST(@ColumnPrecision  AS VARCHAR(255)) +''' AS ErrorMessage 
				FROM HMRC.Data_Staging
				WHERE ISNUMERIC(COALESCE(LTRIM(RTRIM('+ @ColumnName + ')),''0'')) = 1
					AND LEN('+ @ColumnName + ') > 0
					AND (CHARINDEX(''.'','+ @ColumnName + ',1) =  0
					OR LEN(RIGHT('+ @ColumnName + ',LEN('+ @ColumnName + ')-CHARINDEX(''.'','+ @ColumnName + ',1))) <> '+ CAST(@ColumnPrecision  AS VARCHAR(255)) +')'

				
				print @sql
				exec(@SQL)

				FETCH NEXT FROM DecimalPlacesTestConfig INTO 
				@ColumnName, @ColumnType, @ColumnLength, @TestName, @ErrorMessage, @ColumnPrecision
			END

			CLOSE DecimalPlacesTestConfig
			DEALLOCATE DecimalPlacesTestConfig



			   
print ''
print 'DECIMAL PLACE TESTS COMPLETE'
print ''

			   
print ''
print 'ISNUMERIC And Nullable TESTS START ON BIT, BIGINT,Long,Int,SMALLINT, TINYINT'
print ''


-- IsNumeric and Nullable match test
  
            SET @SQL=''

			DECLARE IsNumericTestConfig CURSOR FOR
			SELECT DVR.ColumnName
				,DVR.ColumnType
				, DVR.ColumnLength
				, DVR.ColumnMinValue
				, DVR.ColumnMaxValue
				, 'IsNumeric Test'
				, 'Numeric type field not Numeric Or Value is out of Range' AS ErrorMessage
			FROM HMRC.Data_Validation_Rules AS DVR
			WHERE   DVR.ColumnType IN ('BIT', 'BIGINT','Long','Int','SMALLINT', 'TINYINT')
			 AND RunChecks=1 and RunNumericChecks=1 

			OPEN IsNumericTestConfig
			FETCH NEXT FROM IsNumericTestConfig INTO 
			@ColumnName, @ColumnType, @ColumnLength,@ColumnMinValue,@ColumnMaxValue, @TestName, @ErrorMessage

			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @SQL='
			   INSERT INTO HMRC.Data_Staging_Rejected
					  ( Record_ID,RunId,ColumnName, TestName, ErrorMessage
					  ) 
			   SELECT Record_ID,
				          RunID 
					,'''+ @ColumnName + ''' AS ColumnName
				    , '''+ @TestName + ''' AS TestName
					, '''+ @ErrorMessage +' Actual: ''+['+@ColumnName+'] AS ErrorMessage
     			 FROM HMRC.Data_Staging
				WHERE (ISNUMERIC(COALESCE(LTRIM(RTRIM(REPLACE('+ @ColumnName + ',''NULL'',''-1''))),''-1'')) = 0 )
				  or (CAST(REPLACE('+ @ColumnName +' ,''NULL'',-1) AS NUMERIC) > '+@ColumnMaxValue+')
				  or (CAST(REPLACE('+ @ColumnName +',''NULL'',-1) AS NUMERIC) < '+@ColumnMinValue+')
 
					   '
				
				PRINT @SQL
				EXEC (@SQL)
			

				FETCH NEXT FROM IsNumericTestConfig INTO 
				@ColumnName, @ColumnType, @ColumnLength,@ColumnMinValue,@ColumnMaxValue, @TestName, @ErrorMessage
			END

			CLOSE IsNumericTestConfig
			DEALLOCATE IsNumericTestConfig


print ''
print 'ISNUMERIC And Nullable TESTS COMPLETE ON BIT, BIGINT,Long,Int,SMALLINT, TINYINT'
print ''

print 'DECIMAL match test : ISDECIMAL AND Nullable Start :'

-- Decimal match test
  
			DECLARE IsDecimalTestConfig CURSOR FOR
			SELECT DVR.ColumnName
				,DVR.ColumnType
				, DVR.ColumnLength
				, DVR.ColumnMinValue
				, DVR.ColumnMaxValue
				, 'Decimal Test'
				, 'Decimal type field not Decimal Or Value is out of Range' AS ErrorMessage
			FROM HMRC.Data_Validation_Rules AS DVR
			WHERE   DVR.ColumnType IN ('Decimal')
			 AND RunChecks=1 and RunNumericChecks=1 

			OPEN IsDecimalTestConfig
			FETCH NEXT FROM IsDecimalTestConfig INTO 
			@ColumnName, @ColumnType, @ColumnLength,@ColumnMinValue,@ColumnMaxValue, @TestName, @ErrorMessage

			WHILE @@FETCH_STATUS = 0
			BEGIN

		        SET @SQL='
			   INSERT INTO HMRC.Data_Staging_Rejected
					  ( Record_ID,RunId,ColumnName, TestName, ErrorMessage
					  ) 
			   SELECT Record_ID,
				          RunID 
					,'''+ @ColumnName + ''' AS ColumnName
				    , '''+ @TestName + ''' AS TestName
					, '''+ @ErrorMessage +' Actual: ''+['+ @ColumnName +'] AS ErrorMessage
     			FROM HMRC.Data_Staging
				WHERE try_convert(decimal,isnull('+ @ColumnName + ',0)) is null 
			      or  convert(decimal(18,5),' + @ColumnName +')  > '+ @ColumnMaxValue +'
				  or  convert(decimal(18,5),' + @ColumnName +')  < '+ @ColumnMinValue +'
                       '
				
				PRINT @SQL
				EXEC (@SQL)

		       FETCH NEXT FROM IsDecimalTestConfig INTO 
			   @ColumnName, @ColumnType, @ColumnLength,@ColumnMinValue,@ColumnMaxValue, @TestName, @ErrorMessage

		   END
				

			CLOSE IsDecimalTestConfig
			DEALLOCATE IsDecimalTestConfig

			


print ''
print ' IS DECIMAL AND Nullable TESTS COMPLETE'
print ''




-- IsNumeric and Fixed Length test
  
            SET @SQL=''

			DECLARE IsNumericTestConfig CURSOR FOR
			SELECT DVR.ColumnName
				,DVR.ColumnType
				, DVR.ColumnLength
				, DVR.ColumnMinValue
				, DVR.ColumnMaxValue
				, 'IsNumeric Test'
				, 'Numeric type field Length fails Specification' AS ErrorMessage
			FROM HMRC.Data_Validation_Rules AS DVR
			WHERE   DVR.ColumnType IN ('BIT', 'BIGINT','Long','Int','DECIMAL','SMALLINT', 'TINYINT')
			 AND RunChecks=1 and RunNumericChecks=1 and RunFixedLengthChecks=1

			OPEN IsNumericTestConfig
			FETCH NEXT FROM IsNumericTestConfig INTO 
			@ColumnName, @ColumnType, @ColumnLength,@ColumnMinValue,@ColumnMaxValue, @TestName, @ErrorMessage

			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @SQL='
			   INSERT INTO HMRC.Data_Staging_Rejected
					  ( Record_ID,RunId,ColumnName, TestName, ErrorMessage
					  ) 
			   SELECT Record_ID,
				          RunID 
					,'''+ @ColumnName + ''' AS ColumnName
				    , '''+ @TestName + ''' AS TestName
					, '''+ @ErrorMessage +' Actual: ''+['+@ColumnName+'] AS ErrorMessage
     			 FROM HMRC.Data_Staging
				WHERE (ISNUMERIC(COALESCE(LTRIM(RTRIM(REPLACE('+ @ColumnName + ',''NULL'',''-1''))),''-1'')) = 0 )
				   or (LEN(REPLACE('+ @ColumnName + ',''NULL'',''''))  <>'+  CAST(@ColumnLength AS varchar(255)) +')

 
					   '
				PRINT @SQL
				EXEC (@SQL)
			

				FETCH NEXT FROM IsNumericTestConfig INTO 
				@ColumnName, @ColumnType, @ColumnLength,@ColumnMinValue,@ColumnMaxValue, @TestName, @ErrorMessage
			END

			CLOSE IsNumericTestConfig
			DEALLOCATE IsNumericTestConfig

print ''
print 'NUMERIC FIXED LENGTH TESTS COMPLETE'
print ''


print ''
print 'NUMERIC NOT NULL TESTS START'
print ''







-- Numeric not null  test
            SET @SQL=''

			DECLARE IsNumNotNullConfig CURSOR FOR
			SELECT DVR.ColumnName
				,DVR.ColumnType
				, DVR.ColumnLength
				, 'Number Not Null Test'
				, 'Not Numeric or Contains Null Or Value Out of Range.' AS ErrorMessage
			FROM HMRC.Data_Validation_Rules AS DVR
			WHERE   DVR.ColumnType IN ('BIT', 'BIGINT','Long','Int','DECIMAL','SMALLINT', 'TINYINT')
			 AND RunChecks=1 and RunNumericChecks=1 and ColumnNullable=0


			OPEN IsNumNotNullConfig
			FETCH NEXT FROM IsNumNotNullConfig INTO 
			@ColumnName, @ColumnType, @ColumnLength, @TestName, @ErrorMessage

			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @SQL='
				INSERT INTO HMRC.Data_Staging_Rejected
					  ( Record_ID,RunId, ColumnName, TestName, ErrorMessage
					  ) 
			   SELECT Record_ID,
				          RunID 
					,'''+ @ColumnName + ''' AS ColumnName
				    , '''+ @TestName + ''' AS TestName
					, '''+ @ErrorMessage +' Actual: ''+ isnull(['+@ColumnName+'],''value is null'') AS ErrorMessage
     			 FROM HMRC.Data_Staging
				WHERE '+ @ColumnName + ' IS NULL
				      OR LTRIM(RTRIM('+@ColumnName+'))=''NULL''
 
					   '
				
				PRINT @SQL
				EXEC (@SQL)

			



				FETCH NEXT FROM IsNumNotNullConfig INTO 
				@ColumnName, @ColumnType, @ColumnLength, @TestName, @ErrorMessage
			END

			CLOSE IsNumNotNullConfig
			DEALLOCATE IsNumNotNullConfig

			


print ''
print 'NUMERIC NOT  NULL TESTS COMPLETE'
print ''


print ''
print 'DATE CHECKS IS DATE AND NULLABLE START'
print ''



 		   
 --Date Checks
           SET @SQL=''

           DECLARE IsDateTestConfig CURSOR FOR
			SELECT DVR.ColumnName
				,DVR.ColumnType
				, DVR.ColumnLength
				, 'IsDate Test'
				, 'Date type field not Date.' AS ErrorMessage
			FROM HMRC.Data_Validation_Rules AS DVR
			WHERE   DVR.ColumnType IN ('DATE')
			  AND RunChecks=1 and RunDateChecks=1 and ColumnNullable=1

			  
			OPEN IsDateTestConfig
			FETCH NEXT FROM IsDateTestConfig INTO 
			@ColumnName, @ColumnType, @ColumnLength, @TestName, @ErrorMessage

			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @SQL='
				INSERT INTO HMRC.Data_Staging_Rejected
					  ( Record_ID,RunId, ColumnName, TestName, ErrorMessage
					  ) 
			   SELECT Record_ID,
				          RunID 
					,'''+ @ColumnName + ''' AS ColumnName
				    , '''+ @TestName + ''' AS TestName
					, '''+ @ErrorMessage +' Actual: ''+['+@ColumnName+'] AS ErrorMessage
     			 FROM
				   (
				     SELECT * FROM  HMRC.Data_Staging
					 WHERE len('+ @ColumnName + ') > 0
				   ) a
			--	WHERE ISDATE(COALESCE(LTRIM(RTRIM(REPLACE(REPLACE('+ @ColumnName + ',''NULL'',''1900-01-01''),''0001-01-01'',''1973-01-01''))),''1900-01-01'')) = 0 	  
	          	WHERE ISDATE('+ @ColumnName + ') = 0 
				
					   '
				
			


				PRINT @SQL
				EXEC (@SQL)
			

				FETCH NEXT FROM IsDateTestConfig INTO 
				@ColumnName, @ColumnType, @ColumnLength, @TestName, @ErrorMessage
			END

			CLOSE IsDateTestConfig
			DEALLOCATE IsDateTestConfig			

print ''
print 'DATE NULLABLE TESTS COMPLETE'
print ''


print ''
print 'DATE CHECKS IS DATE AND NOT NULLABLE START'
print ''
 		   
 --Date Checks
           SET @SQL=''

           DECLARE IsDateTestConfig CURSOR FOR
			SELECT DVR.ColumnName
				,DVR.ColumnType
				, DVR.ColumnLength
				, 'IsDate Test'
				, 'Date type field is NULL OR is Not Date ' AS ErrorMessage
			FROM HMRC.Data_Validation_Rules AS DVR
			WHERE   DVR.ColumnType IN ('DATE')
			  AND RunChecks=1 and RunDateChecks=1 and ColumnNullable=0

			  
			OPEN IsDateTestConfig
			FETCH NEXT FROM IsDateTestConfig INTO 
			@ColumnName, @ColumnType, @ColumnLength, @TestName, @ErrorMessage

			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @SQL='
				INSERT INTO HMRC.Data_Staging_Rejected
					  ( Record_ID,RunId, ColumnName, TestName, ErrorMessage
					  ) 
			   SELECT Record_ID,
				          RunID 
					,'''+ @ColumnName + ''' AS ColumnName
				    , '''+ @TestName + ''' AS TestName
					, '''+ @ErrorMessage +' Actual: ''+ isnull(['+@ColumnName+'],''Date is null'') AS ErrorMessage
     			 FROM	 HMRC.Data_Staging
				 WHERE ISDATE('+ @ColumnName + ') = 0 
			'

				PRINT @SQL
				EXEC (@SQL)
			

				FETCH NEXT FROM IsDateTestConfig INTO 
				@ColumnName, @ColumnType, @ColumnLength, @TestName, @ErrorMessage
			END

			CLOSE IsDateTestConfig
			DEALLOCATE IsDateTestConfig			

print 'DATE CHECKS IS DATE AND NOT NULLABLE COMPLETE'






  
-- Pattern Match Test

            DECLARE PatternMatchTestConfig CURSOR FOR
			SELECT DVR.ColumnName
				, DVR.ColumnType
				, DVR.ColumnLength
				, 'Pattern Matching Test'
				, 'Column pattern does not match specification.' AS ErrorMessage
				, DVR.ColumnPattern
			FROM HMRC.Data_Validation_Rules AS DVR
			WHERE  RunChecks=1 and RunPatternMatchChecks = 1

		--	select * from  HMRC.Data_Validation_Rules
			   

			OPEN PatternMatchTestConfig
			FETCH NEXT FROM PatternMatchTestConfig INTO 
			@ColumnName, @ColumnType, @ColumnLength, @TestName, @ErrorMessage, @ColumnPatternMatching

			WHILE @@FETCH_STATUS = 0
			BEGIN
			
		  	SET @SQL='
				INSERT INTO HMRC.Data_Staging_Rejected
					  ( Record_ID,RunId, ColumnName, TestName, ErrorMessage
					  ) 
			   SELECT Record_ID,
				          RunID 
					,'''+ @ColumnName + ''' AS ColumnName
				    , '''+ @TestName + ''' AS TestName
					, '''+ @ErrorMessage +  @ErrorMessage +' Actual: ''+ CAST('+ @ColumnName +' AS VARCHAR(255)) +'' Expected Pattern: '+ @ColumnPatternMatching +''' AS ErrorMessage
     			FROM HMRC.Data_Staging
				WHERE LTRIM(RTRIM('+ @ColumnName + ')) NOT LIKE '''+ @ColumnPatternMatching +'''
				'
				
				print @sql
				EXEC (@SQL)
			

				FETCH NEXT FROM PatternMatchTestConfig INTO 
				@ColumnName, @ColumnType, @ColumnLength, @TestName, @ErrorMessage, @ColumnPatternMatching
			END
			

			CLOSE PatternMatchTestConfig
			DEALLOCATE PatternMatchTestConfig
			
			

/* Update Staging Tables with Valid/Invalid Flag */

   
   UPDATE a
      SET a.IsValid=0
	     ,a.InvalidReason=b.ErrorMessage
	 FROM HMRC.Data_Staging a
	 JOIN HMRC.Data_Staging_Rejected b
	   ON a.Record_ID=b.Record_ID
	  AND a.RunID=b.RunID




/* Update Log Execution Results as Success if the query ran successfully*/

UPDATE HMRC.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
 WHERE LogId=@LogID
   AND RunID=@Run_Id

/* Update Invalid Record Counts in Log Table */

  -- select InvalidReason from  HMRC.Data_Staging
  
   INSERT INTO HMRC.Log_Record_Counts
   (LogId,RunId,SourceTableName,TargetTableName,SourceRecordCount,TargetRecordCount,InvalidRecordCount)
   SELECT @LogID
         ,@Run_Id
		 ,'HMRC.Data_Staging'
	     ,'HMRC.Data_Staging_Rejected'
		 ,(SELECT COUNT(*) FROM HMRC.Data_Staging WHERE RunID= @Run_ID)
		 ,(SELECT COUNT(*) FROM HMRC.Data_Staging WHERE RunID = @Run_ID and IsValid=0)
         ,(SELECT COUNT(DISTINCT Record_ID) FROM HMRC.Data_Staging_Rejected WHERE RunId= @Run_ID)		                                   




END TRY
BEGIN CATCH

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
	    'HMRC_RunValidationChecks' AS ErrorProcedure,
	    ERROR_MESSAGE(),
	    GETDATE(),
		@Run_Id as RunId; 

  SELECT @ErrorId =MAX(ErrorId) FROM HMRC.Log_Error_Details

/* Update Log Execution Results as Fail if there is an Error*/

UPDATE HMRC.Log_Execution_Results
   SET Execution_Status=0
      ,EndDateTime=getdate()
	  ,ErrorId=@ErrorId
 WHERE LogId=@LogID
   AND RunID=@Run_Id


END CATCH









