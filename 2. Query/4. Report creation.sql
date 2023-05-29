	drop table `Validate`

go

	create table `Validate`
	(
		`Order ID` int,
		`AWB code` bigint,
		`Total weight as per courier company (kg)` numeric (5,2),
		`Total weight as per Myntra (kg)` numeric (5,2),
		`Weight slab as per courier company (kg)` numeric (5,1),
		`Weight slab as per Myntra (kg)` numeric (5,1),
		`Delivery zone as per courier company` nvarchar(1),
		`Delivery zone as per Myntra` nvarchar(1),
		`Billed charge by courier company (INR)` numeric (5,1),
		`Expected charge as per Myntra (INR)` numeric (5,1),
		`Difference between expected charge and billed charge (INR)` numeric (5,1)
	)

go

	drop table `Summary`

go

	create table `Summary`
	(
		`Type` nvarchar(30),
		`Count` int,
		`Amount (INR)` numeric (5,1)
	)