/* Delete input tables */

/* Delete table: [Order report] */
	drop table if exists [Myntra].[dbo].[Order report];
/* Create table: [Order report] */
	create table [Myntra].[dbo].[Order report]
	(
		[External order number] int NOT NULL,
		[SKU] nvarchar(15) NULL,
		[Order quantity] int NULL
	);

/* Delete table: [SKU] */
	drop table if exists [Myntra].[dbo].[SKU];
/* Create table: [SKU] */
	create table [Myntra].[dbo].[SKU]
	(
		[SKU] nvarchar(15) NOT NULL,
		[Weight (g)] int NULL
	);

/* Delete table: [Pincode zones] */
	drop table if exists [Myntra].[dbo].[Pincode zones];
/* Create table: [Pincode zones] */
	create table [Myntra].[dbo].[Pincode zones]
	(
		[Warehouse pincode]	int NOT NULL,
		[Customer pincode]	int NOT NULL,
		[Zone] char(1) NULL
	);

/* Delete table: [Invoice] */
	drop table if exists [Myntra].[dbo].[Invoice];
/* Create table: [Invoice] */
	create table [Myntra].[dbo].[Invoice]
	(
		[AWB code] bigint NOT NULL,
		[Order ID]	int NOT NULL,
		[Charged weight] float NULL,
		[Warehouse pincode]	int NOT NULL,
		[Customer pincode]	int NOT NULL,
		[Zone] char(1) NULL,
		[Type of shipment] varchar(25) NULL,
		[Billing amount (INR)] float NULL
	);

/* Delete table: [Rates] */
	drop table if exists [Myntra].[dbo].[Rates];
/* Create table: [Rates] */
	create table [Myntra].[dbo].[Rates]
	(
		[Shipment code]	nvarchar(20) NOT NULL,
		[Shipment cost] float NULL
	);

/* Delete output tables */
/* Delete table: [Validate] */
	drop table if exists [Myntra].[dbo].[Validate];
/* Create table: [Validate] */
	create table [Myntra].[dbo].[Validate]
	(
		[Order ID] int NOT NULL,
		[AWB code] bigint NULL,
		[Total weight as per courier company (kg)] decimal(5,2) NULL,
		[Total weight as per Myntra (kg)] decimal(5,2) NULL,
		[Weight slab as per courier company (kg)] decimal(5,1) NULL,
		[Weight slab as per Myntra (kg)] decimal(5,1) NULL,
		[Delivery zone as per courier company] char(1) NULL,
		[Delivery zone as per Myntra] char(1) NULL,
		[Billed charge by courier company (INR)] decimal(5,1) NULL,
		[Expected charge as per Myntra (INR)] decimal(5,1) NULL,
		[Difference between expected charge and billed charge (INR)] decimal(5,1) NULL
	);

/* Delete table: [Summary] */
	drop table if exists [Myntra].[dbo].[Summary];
/* Create table: [Summary] */
	create table [Myntra].[dbo].[Summary]
	(
		[Type] nvarchar(30) NOT NULL,
		[Count] int NULL,
		[Amount (INR)] decimal(5,1) NULL
	);