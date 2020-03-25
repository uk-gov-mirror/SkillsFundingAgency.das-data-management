

CREATE TABLE [StgPmts].[JobProviderEarnings](
	[JobId] [bigint] NOT NULL,
	[DCJobId] [bigint] NOT NULL,
	[Ukprn] [bigint] NOT NULL,
	[IlrSubmissionTime] [datetime2](7) NOT NULL,
	[CollectionYear] [varchar](4) NOT NULL,
	[CollectionPeriod] [tinyint] NOT NULL
) 