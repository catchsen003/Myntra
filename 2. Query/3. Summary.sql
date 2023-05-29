/*	
	Table name:
		Summary
	Purpose:
		Calculate all output columns in desired format
	Columns:
		An excel file with following details as columns:
		1. Type
		2. Count
		3. Amount (INR)
*/
	insert into [Myntra].[dbo].[Summary]
	select
		'Correctly charged orders'
		as [Type],
		count(*)
		as [Count],
		sum([Difference between expected charge and billed charge (INR)])
		as [Amount (INR)]
	from [Myntra].[dbo].[Validate]
	where [Difference between expected charge and billed charge (INR)]=0
	/* union all - execution time is less than the execution time of union as it does not removes duplicate rows */
	union all
	select
		'Over charged orders'
		as [Type],
		count(*)
		as [Count],
		sum([Difference between expected charge and billed charge (INR)])
		as [Amount (INR)]
	from [Myntra].[dbo].[Validate]
	where [Difference between expected charge and billed charge (INR)]<0
	/* union all - execution time is less than the execution time of union as it does not removes duplicate rows */
	union all
	select
		'Under charged orders'
		as [Type],
		count(*)
		as [Count],
		sum([Difference between expected charge and billed charge (INR)])
		as [Amount (INR)]
	from [Myntra].[dbo].[Validate]
	where [Difference between expected charge and billed charge (INR)]>0;