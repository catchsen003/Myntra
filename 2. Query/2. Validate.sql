/*	
	Table name:
		Validate
	Purpose:
		Derive metrics for both courier company and Myntra.
		Perform calculations separately for each entity and then analyze the results.  
	Columns:
		An excel file with following details as columns:
		1. Order ID
		2. AWB code
		3. Total weight as per courier company (kg)
		4. Total weight as per Myntra (kg)
		5. Weight slab as per courier company (kg)
		6. Weight slab as per Myntra (kg)
		7. Delivery zone as per courier company
		8. Delivery zone as per Myntra
		9. Billed charge by courier company (INR)
		10. Expected charge as per Myntra (INR)
		11. Difference between expected charge and billed charge (INR)
*/

/*
	CTE name: 
		cte_column_4
	Purpose:
		Calculate column 4: Total weight as per Myntra (kg)
*/
	with cte_column_4 as
	(
		select
			[External order number],
			cast(sum([Order Report].[Order quantity]*[Weight (g)]*1.0)/1000 as decimal(5,2))
			as [Total weight as per Myntra (kg)]
		from [Myntra].[dbo].[Order Report]
		join [Myntra].[dbo].[SKU]
			on [Order Report].[SKU]=[SKU].[SKU]
		group by [External order number]
	),

/*
	CTE name:
		cte_column_5
	Purpose:
		Calculate column 5: Weight slab as per courier company (kg)
*/
	cte_column_5 as 
	(
		select
			[Order ID],[Charged weight], 
		case 
			when [Charged weight] between 0.01 and 0.50 then 0.5
			when [Charged weight] between 0.51 and 1.00 then 1
			when [Charged weight] between 1.01 and 1.50 then 1.5
			when [Charged weight] between 1.51 and 2.00 then 2
			when [Charged weight] between 2.01 and 2.50 then 2.5
			when [Charged weight] between 2.51 and 3.00 then 3
			when [Charged weight] between 3.01 and 3.50 then 3.5
			when [Charged weight] between 3.51 and 4.00 then 4
			when [Charged weight] between 4.01 and 4.50 then 4.5
			when [Charged weight] between 4.51 and 5.00 then 5
		end
		as [Weight slab as per courier company (kg)]
		from [Myntra].[dbo].[Invoice]
	),

/*
	CTE name:
		cte_column_6
	Purpose:
		Calculate column 6: Weight slab as per Myntra (kg)
*/
	cte_column_6 as 
	(
		select *,
		case
			when [Total weight as per Myntra (kg)] between 0.01 and 0.50 then 0.5
			when [Total weight as per Myntra (kg)] between 0.51 and 1.00 then 1
			when [Total weight as per Myntra (kg)] between 1.01 and 1.50 then 1.5
			when [Total weight as per Myntra (kg)] between 1.51 and 2.00 then 2
			when [Total weight as per Myntra (kg)] between 2.01 and 2.50 then 2.5
			when [Total weight as per Myntra (kg)] between 2.51 and 3.00 then 3
			when [Total weight as per Myntra (kg)] between 3.01 and 3.50 then 3.5
			when [Total weight as per Myntra (kg)] between 3.51 and 4.00 then 4
			when [Total weight as per Myntra (kg)] between 4.01 and 4.50 then 4.5
			when [Total weight as per Myntra (kg)] between 4.51 and 5.00 then 5
		end
		as [Weight slab as per Myntra (kg)]
		from cte_column_4
	),


/*
	CTE name:
		cte_column_8
	Purpose:
		Calculate column 8: Delivery zone as per Myntra
*/
	cte_column_8 as
	(
		select
			[Invoice].[Warehouse pincode],[Invoice].[Customer pincode],
			[Pincode zones].[Zone]
			as [Delivery zone as per Myntra]
		from [Myntra].[dbo].[Invoice]
		join [Myntra].[dbo].[Pincode zones]
			on [Invoice].[Warehouse pincode]=[Pincode zones].[Warehouse pincode] and [Invoice].[Customer pincode]=[Pincode zones].[Customer pincode]
	),

/* 
	CTE name:
		cte_temp_table_01
	Purpose:
		Calculate lot sizes (multiples) of weight slabs and combine those values with previously computed CTE columns
*/
	cte_temp_table_01 as 
	(
		select 
			distinct([Invoice].[Order ID]) as [Order ID],
			[Invoice].[AWB code],
			cte_column_4.[Total weight as per Myntra (kg)],
			cte_column_6.[Weight slab as per Myntra (kg)],
			cast([Invoice].[Charged weight] as decimal(5,2)) as [Total weight as per courier company (kg)],
			cte_column_5.[Weight slab as per courier company (kg)],
			cte_column_8.[Delivery zone as per Myntra],
			[Invoice].[Zone] as [Delivery zone as per courier company],
			[Invoice].[Type of shipment],
			cast([Weight slab as per Myntra (kg)]/0.5 as int)
			as [Total_no.of times],
			(cast([Weight slab as per Myntra (kg)]/0.5 as int) - (cast([Weight slab as per Myntra (kg)]/0.5 as int)-1))
			as [Fixed_no.of times],
			(cast([Weight slab as per Myntra (kg)]/0.5 as int)-1)
			as [Additional_no.of times],
			cast([Invoice].[Billing amount (INR)] as decimal(5,1))
			as [Billed charge by courier company (INR)]
		from [Myntra].[dbo].[Invoice]
		join [Myntra].[dbo].[Order report]
			on [Invoice].[Order ID]=[Order report].[External order number]
		join [Myntra].[dbo].[SKU]
			on [Order report].[SKU]=[SKU].[SKU]
		join cte_column_4
			on cte_column_4.[External order number]=[Order report].[External order number]
		join cte_column_6
			on cte_column_6.[External order number]=[Order report].[External order number]
		join cte_column_5
			on cte_column_5.[Order ID]=[Order report].[External order number]
		join cte_column_8
			on cte_column_8.[Warehouse pincode]=[Invoice].[Warehouse pincode] and cte_column_8.[Customer pincode]=[Invoice].[Customer pincode]
	),

/* 
	CTE name:
		cte_temp_table_02
	Purpose:
		Calculate charges per Order ID: [Expected charge as per Myntra (INR)] and combining those values with previously computed CTE columns
*/
	cte_temp_table_02 as 
	(
		select *,
		case 
			/* case 1: Delivery zone - 'a' and Type of shipment - 'Forward charges' */
				when [Delivery zone as per Myntra]='a' and [Type of shipment]='Forward charges' 
				then 
					(((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_a_fixed')*[Fixed_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_a_additional')*[Additional_no.of times]))
			/* case 2: Delivery zone - 'b' and Type of shipment - 'Forward charges' */
				when [Delivery zone as per Myntra]='b' and [Type of shipment]='Forward charges' 
				then 
					(((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_b_fixed')*[Fixed_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_b_additional')*[Additional_no.of times]))
			/* case 3: Delivery zone - 'c' and Type of shipment - 'Forward charges' */
				when [Delivery zone as per Myntra]='c' and [Type of shipment]='Forward charges' 
				then 
					(((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_c_fixed')*[Fixed_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_c_additional')*[Additional_no.of times]))
			/* case 4: Delivery zone - 'd' and Type of shipment - 'Forward charges' */
				when [Delivery zone as per Myntra]='d' and [Type of shipment]='Forward charges' 
				then 
					(((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_d_fixed')*[Fixed_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_d_additional')*[Additional_no.of times]))
			/* case 5: Delivery zone - 'e' and Type of shipment - 'Forward charges' */
				when [Delivery zone as per Myntra]='e' and [Type of shipment]='Forward charges' 
				then 
					(((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_e_fixed')*[Fixed_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_e_additional')*[Additional_no.of times]))
			/* case 6: Delivery zone - 'a' and Type of shipment - 'Forward and RTO charges' */
				when [Delivery zone as per Myntra]='a' and [Type of shipment]='Forward and RTO charges' 
				then 
					(((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_a_fixed')*[Fixed_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_a_additional')*[Additional_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'rto_a_fixed')*[Fixed_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'rto_a_additional')*[Additional_no.of times]))
			/* case 7: Delivery zone - 'b' and Type of shipment - 'Forward and RTO charges' */
				when [Delivery zone as per Myntra]='b' and [Type of shipment]='Forward and RTO charges' 
				then 
					(((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_b_fixed')*[Fixed_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_b_additional')*[Additional_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'rto_b_fixed')*[Fixed_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'rto_b_additional')*[Additional_no.of times]))
			/* case 8: Delivery zone - 'c' and Type of shipment - 'Forward and RTO charges' */
				when [Delivery zone as per Myntra]='c' and [Type of shipment]='Forward and RTO charges' 
				then 
					(((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_c_fixed')*[Fixed_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_c_additional')*[Additional_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'rto_c_fixed')*[Fixed_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'rto_c_additional')*[Additional_no.of times]))
			/* case 9: Delivery zone - 'd' and Type of shipment - 'Forward and RTO charges' */
				when [Delivery zone as per Myntra]='d' and [Type of shipment]='Forward and RTO charges' 
				then 
					(((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_d_fixed')*[Fixed_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_d_additional')*[Additional_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'rto_d_fixed')*[Fixed_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'rto_d_additional')*[Additional_no.of times]))
			/* case 10: Delivery zone - 'e' and Type of shipment - 'Forward and RTO charges' */
				when [Delivery zone as per Myntra]='e' and [Type of shipment]='Forward and RTO charges' 
				then 
					(((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_e_fixed')*[Fixed_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'fwd_e_additional')*[Additional_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'rto_e_fixed')*[Fixed_no.of times])+
					((select [Shipment Cost] from [Myntra].[dbo].[Rates] where [Shipment Code] = 'rto_e_additional')*[Additional_no.of times]))
		end as [Expected charge as per Myntra (INR)]
		from cte_temp_table_01
	)

/* 
	Main query
	Purpose:
		Modify output columns in desired format and calculate column 11: [Difference between expected charge and billed charge (INR)]
	Target table name:
		Validate
*/
	insert into [Myntra].[dbo].[Validate]
	select
		[Order ID],
		[AWB code],
		[Total weight as per courier company (kg)],
		[Total weight as per Myntra (kg)],
		[Weight slab as per courier company (kg)],
		[Weight slab as per Myntra (kg)],
		UPPER([Delivery zone as per courier company]),
		UPPER([Delivery zone as per Myntra]),
		[Billed charge by courier company (INR)],
		cast([Expected charge as per Myntra (INR)] as decimal(5,1))
		as [Expected charge as per Myntra (INR)],
		cast([Expected charge as per Myntra (INR)]-[Billed charge by courier company (INR)] as decimal(5,1))
		as [Difference between expected charge and billed charge (INR)]
	from cte_temp_table_02
	order by [Order ID];