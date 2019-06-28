﻿CREATE PROCEDURE [dbo].[uSP_Build_AS_DataMart]
AS
-- ==========================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Master Stored Proc that builds AS DataMart
-- ==========================================================

/* Generate Run Id for Logging Execution */

DECLARE @RunId int

EXEC @RunId= dbo.uSP_Generate_RunId

EXEC uSP_Create_System_External_Tables 'comtDBConnection','Commitments',@RunId

--EXEC uSP_Create_System_External_Tables 'easaccDBConnection','Accounts',@RunId

--EXEC uSP_Create_System_External_Tables 'usersDBConnection','Users',@RunId

EXEC dbo.uSP_Create_External_Tables 'comtDBConnection','Ext_Tbl_InfSch_Commitments',@RunId

--EXEC dbo.uSP_Create_External_Tables 'easaccDBConnection','Ext_Tbl_InfSch_Accounts',@RunId

--EXEC dbo.uSP_Create_External_Tables 'usersDBConnection','Ext_Tbl_InfSch_Users',@RunId

EXEC dbo.uSP_Import_Provider @RunId

EXEC dbo.uSP_Import_Employer @RunId

