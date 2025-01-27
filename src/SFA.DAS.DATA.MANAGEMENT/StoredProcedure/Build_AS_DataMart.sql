﻿CREATE PROCEDURE [dbo].[Build_AS_DataMart]
AS
-- ==========================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Master Stored Proc that builds AS DataMart
-- ==========================================================


/* Generate Run Id for Logging Execution */

DECLARE @RunId int

EXEC @RunId= dbo.GenerateRunId

EXEC CreateSystemExternalTables 'comtDBConnection','Commitments','Comt',@RunId

EXEC CreateExternalTables 'comtDBConnection','Ext_Tbl_InfSch_Commitments','Comt',@RunId

EXEC CreateSystemExternalTables 'rsrvDBConnection','Reservations','Resv',@RunId

EXEC CreateExternalTables 'rsrvDBConnection','Ext_Tbl_InfSch_Reservations','Resv',@RunId

EXEC CreateSystemExternalTables 'easfinDBConnection','Finance','Fin',@RunId

EXEC CreateExternalTables 'easfinDBConnection','Ext_Tbl_InfSch_Finance','Fin',@RunId

EXEC CreateSystemExternalTables 'usersDBConnection','Users','EAUser',@RunId

EXEC CreateExternalTables 'usersDBConnection','Ext_Tbl_InfSch_Users','EAUser',@RunId

EXEC CreateSystemExternalTables 'easAccDBConnection','Account','Acct',@RunId

EXEC CreateExternalTables 'easAccDBConnection','Ext_Tbl_InfSch_Account','Acct',@RunId

EXEC UpdateCalendarMonth @RunId

EXEC LoadReferenceData @RunId

EXEC PopulateSourceDbMetadataForImport @RunId

EXEC CreateCommitmentsView @RunId

EXEC CreateLevyDeclarationsView @RunId


EXEC CreatePaymentsView @RunId

EXEC CreateEmployerAccountTransactionsView @RunId

EXEC CreateEmployerAccountTransfersView @RunId 



EXEC CreateEmployerPAYESchemesView @RunId 

EXEC CreateEmployerLegalEntitiesView @RunId 

EXEC CreateEmployerLegalEntitiesView_LevyInd @RunId

EXEC CreateEmployerAccountsView @RunId 

EXEC CreateEmployerTransferRelationshipView @RunId 

EXEC CreateTransactionLineView @RunId 

EXEC CreateEmployerAgreementsView @RunId

EXEC CreateCommitmentsView_LevyInd @RunId

EXEC CreateSpendControlView @RunId

EXEC CreateSpendControlNonLevyView @RunId

EXEC LoadCandidateEthLookUp @RunId

EXEC LoadCandidateConfig @RunId

/* Refresh Payments Snapshot Table */

-- EXEC ImportPaymentsSnapshot @RunId

EXEC CreatePaymentsView_LevyInd  @RunId


/* Load Commitments into Modelled Data Tables */

--EXEC ImportCommitmentsDb @RunId

EXEC [dbo].[CreateStdsAndFrameworksView] @RunID

EXEC [dbo].[CreateDashboardRegistrationView] @RunID

EXEC [dbo].[CreateDashboardReservationView] @RunID

EXEC [dbo].[CreateDashboardReservationAndTrainingView] @RunID

EXEC [dbo].[CreateDashboardReservationAndCommitmentView] @RunID

EXEC [dbo].[UpdateApprenticeshipStdRoute] @RunID

EXEC [dbo].[CreateDataDictionaryView] @RunID


/* Populate Metadata for Marketo Import */

EXEC [dbo].[PopulateMarketoFilterConfigForImport] @RunId

EXEC [dbo].[PopulateMetadataForRefreshDataset] @RunId

EXEC [dbo].[PopulateMetadataNationalMinimumWageRates] @RunId