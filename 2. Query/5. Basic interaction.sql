/* View entire table */
	select * from [Myntra].[dbo].[Order report];
	select * from [Myntra].[dbo].[SKU];
	select * from [Myntra].[dbo].[Pincode zones];
	select * from [Myntra].[dbo].[Invoice];
	select * from [Myntra].[dbo].[Rates];
	select * from [Myntra].[dbo].[Validate];
	select * from [Myntra].[dbo].[Summary];

/* View first row of table */
	select top 1 * from [Myntra].[dbo].[Order report];
	select top 1 * from [Myntra].[dbo].[SKU];
	select top 1 * from [Myntra].[dbo].[Pincode zones];
	select top 1 * from [Myntra].[dbo].[Invoice];
	select top 1 * from [Myntra].[dbo].[Rates];
	select top 1 * from [Myntra].[dbo].[Validate];
	select top 1 * from [Myntra].[dbo].[Summary];

/* Empty table */
	truncate table [Myntra].[dbo].[Order report];
	truncate table [Myntra].[dbo].[SKU];
	truncate table [Myntra].[dbo].[Pincode zones];
	truncate table [Myntra].[dbo].[Invoice];
	truncate table [Myntra].[dbo].[Rates];
	truncate table [Myntra].[dbo].[Validate];
	truncate table [Myntra].[dbo].[Summary];

/* Empty table */
	drop table [Myntra].[dbo].[Order report];
	drop table [Myntra].[dbo].[SKU];
	drop table [Myntra].[dbo].[Pincode zones];
	drop table [Myntra].[dbo].[Invoice];
	drop table [Myntra].[dbo].[Rates];
	drop table [Myntra].[dbo].[Validate];
	drop table [Myntra].[dbo].[Summary];