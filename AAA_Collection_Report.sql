#=========== START Yoshi request to check the payment of each customer every day =========
SELECT 
	c.contract_no ,
	c.ncn ,
	c.contract_date ,
	p.loan_amount ,
	p.trading_currency ,
	CASE
		c.status WHEN 0 THEN 'Pending'
		WHEN 1 THEN 'Pending Approval'
		WHEN 2 THEN 'Pending Disbursement'
		WHEN 3 THEN 'Disbursement Approval'
		WHEN 4 THEN 'Active'
		WHEN 5 THEN 'Cancelled'
		WHEN 6 THEN 'Refinance'
		WHEN 7 THEN 'Closed'
		ELSE NULL
	END contract_status,
	p.no_of_payment ,
	/*CASE p.no_of_payment WHEN 105 THEN 'no collect holidays and weekend'
		WHEN 273 THEN 'no collect holidays and weekend'
		ELSE 'collect every days'
	END `payment_type`,*/
	NULL `payment_type`,
	cu.id 'customer_id',
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo , " ",cu.customer_last_name_lo ) using latin1) as binary) using utf8) 'customer_full_name_lo',
	cu.main_contact_no 'customer_tel1',
	concat(us.staff_no," - ", us.nickname) 'salesperson',
	NULL 'current_salesperson',
	NUll 'daily_payment_amount',
	SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 62 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-01',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 61 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-02',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 60 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-03',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 59 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-04',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 58 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-05',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 57 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-06',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 56 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-07',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 55 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-08',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 54 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-09',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 53 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-10',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 52 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-11',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 51 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-12',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 50 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-13',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 49 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-14',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 48 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-15',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 47 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-16',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 46 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-17',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 45 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-18',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 44 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-19',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 43 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-20',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 42 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-21',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 41 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-22',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 40 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-23',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 39 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-24',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 38 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-25',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 37 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-26',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 36 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-27',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 35 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-28',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 34 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-29',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 33 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-30',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 32 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12-31',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 31 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-01',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 30 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-02',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 29 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-03',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 28 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-04',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 27 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-05',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 26 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-06',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 25 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-07',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 24 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-08',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 23 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-09',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 22 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-10',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 21 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-11',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 20 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-12',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 19 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-13',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 18 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-14',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 17 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-15',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 16 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-16',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 15 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-17',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 14 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-18',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 13 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-19',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 12 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-20',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 11 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-21',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 10 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-22',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 9 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-23',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 8 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-24',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 7 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-25',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 6 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-26',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 5 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-27',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 4 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-28',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 3 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-29',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 2 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-30',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 1 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-01-31',
SUM(CASE WHEN co.date_collected = DATE_ADD(date(now()), INTERVAL - 0 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2023-02-01',
SUM(CASE WHEN co.date_collected >= DATE_ADD(date(now()), INTERVAL - 14 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) 'total_paid_amount(14days_ago)',
SUM(CASE WHEN co.date_collected >= DATE_ADD(date(now()), INTERVAL - 14 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.principal_payment_amount END) 'paid_principal(14days_ago)',
SUM(CASE WHEN co.date_collected >= DATE_ADD(date(now()), INTERVAL - 14 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.interest_payment_amount END) 'paid_interest(14days_ago)',
SUM(CASE WHEN co.date_collected >= DATE_ADD(date(now()), INTERVAL - 14 DAY) and (co.status = 1 or co.payment_amount = 0) THEN co.penalty_payment_amount END) 'paid_penalty(14days_ago)',
	NOW() 'datetime_updated' 
FROM tblcontract c 
LEFT JOIN tblcollection co ON (c.id = co.contract_id)
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
left join tblcustomer cu on (cu.id = p.customer_id)
left join tbluser us on (us.id = p.salesperson_id)
left join tbluser uc on (uc.id = p.current_salesperson_id)
WHERE p.contract_type = 5 and c.status in (4,6,7) -- and co.status = 1
group by c.contract_no 
order by c.contract_no desc;





#============ START Check collection payment for Sack 43 Collection AAA collection payment sheet daily_report ===========
SELECT 
	c.contract_no ,
	p.first_payment_date ,
	p.last_payment_date ,
	ps.payment_date 'date_already_paid',
	p.no_of_payment ,
	DATEDIFF(ps.payment_date, p.first_payment_date - 1) 'no_of_already_paid' ,
	CASE WHEN c.status = 6 OR c.status = 7 THEN 0 
		WHEN p.first_payment_date >= DATE(NOW()) THEN 0
		WHEN c.status = 4 THEN DATEDIFF(DATE(NOW()), ps.payment_date ) 
	END 'delay_days_after_date_already_paid' ,
	CASE WHEN c.status = 6 OR c.status = 7 THEN 0 WHEN c.status = 4 THEN DATEDIFF(DATE(NOW()), p.last_payment_date ) END 'delay_days_after_last_payment_date' ,
	CASE WHEN c.status = 6 THEN 'already paid' WHEN c.status = 7 THEN 'already paid'
		WHEN DATEDIFF(DATE(NOW()),  p.first_payment_date) < 1 THEN 'already paid'
		WHEN DATEDIFF(DATE(NOW()),  p.first_payment_date) >= 1 THEN 'not paid'
		WHEN DATEDIFF(DATE(NOW()),  ps.payment_date) <= 1 THEN 'already paid'
		WHEN DATEDIFF(DATE(NOW()),  ps.payment_date) > 1 THEN 'not paid'
		ELSE NULL
	END 'payment_status',
	CASE WHEN c.status = 6 OR c.status = 7 THEN 'White'
		-- WHEN p.initial_date >= '2022-02-01' THEN 'White' -- request from Morikawa on 2022-01-05
		WHEN DATEDIFF(DATE(NOW()),  p.first_payment_date) - 1 <= 10 THEN 'White'
		WHEN DATEDIFF(DATE(NOW()),  ps.payment_date) - 1 <= 10 THEN 'White'
		WHEN DATEDIFF(DATE(NOW()),  p.first_payment_date) - 1 <= 30 THEN 'Grey'
		WHEN DATEDIFF(DATE(NOW()),  ps.payment_date) - 1 <= 30 THEN 'Grey'
		WHEN DATEDIFF(DATE(NOW()),  p.first_payment_date) - 1 > 30 THEN 'Black'
		WHEN DATEDIFF(DATE(NOW()),  ps.payment_date) - 1 > 30 THEN 'Black'
		ELSE NULL
	END 'collection_status',
	-- DATEDIFF(DATE(NOW()),  ps.payment_date), DATEDIFF(DATE(NOW()),  p.first_payment_date),
	CASE
		c.status WHEN 0 THEN 'Pending'
		WHEN 1 THEN 'Pending Approval'
		WHEN 2 THEN 'Pending Disbursement'
		WHEN 3 THEN 'Disbursement Approval'
		WHEN 4 THEN 'Active'
		WHEN 5 THEN 'Cancelled'
		WHEN 6 THEN 'Refinance'
		WHEN 7 THEN 'Closed'
		ELSE NULL
	END contract_status
FROM tblcontract c
LEFT JOIN tblprospect p ON (c.prospect_id = p.id)
LEFT JOIN tblpaymentschedule ps ON ps.id = (SELECT id FROM tblpaymentschedule WHERE status = 1 and payment_amount !=0 and contract_id = c.id ORDER BY payment_date DESC LIMIT 1)
WHERE c.status in (4,6,7) and p.contract_type = 5 -- and p.id in (3168)
GROUP BY c.prospect_id;





#============= Calculate the paid amount and outstanding amount Sheet Yoshi ================
SELECT c.contract_no , c.ncn , p.trading_currency ,
	SUM(pm.amount) 'total_amount',
	SUM(CASE WHEN pm.`type` = 'principal' THEN pm.amount END) 'principal',
	SUM(CASE WHEN pm.`type` = 'interest' THEN pm.amount END) 'interest',
	SUM(CASE WHEN pm.`type` = 'penalty' THEN pm.amount END) 'penalty',
	SUM(pm.paid_amount) 'total_paid_amount',
	SUM(CASE WHEN pm.`type` = 'principal' THEN pm.paid_amount END) 'paid_principal',
	SUM(CASE WHEN pm.`type` = 'interest' THEN pm.paid_amount END) 'paid_interest',
	SUM(CASE WHEN pm.`type` = 'penalty' THEN pm.paid_amount END) 'paid_penalty',
	SUM(pm.refinance_amount + pm.void_amount) 'total_void_amount',
	SUM(CASE WHEN pm.`type` = 'principal' THEN pm.refinance_amount + pm.void_amount END) 'void_principal',
	SUM(CASE WHEN pm.`type` = 'interest' THEN pm.refinance_amount + pm.void_amount  END) 'void_interest',
	SUM(CASE WHEN pm.`type` = 'penalty' THEN pm.refinance_amount + pm.void_amount  END) 'void_penalty',
	SUM(pm.amount - pm.paid_amount - (pm.refinance_amount + pm.void_amount)) 'total_outstanding_amount',
	SUM(CASE WHEN pm.`type` = 'principal' THEN pm.amount - pm.paid_amount - (pm.refinance_amount + pm.void_amount) END) 'principal_outstanding',
	SUM(CASE WHEN pm.`type` = 'interest' THEN pm.amount - pm.paid_amount - (pm.refinance_amount + pm.void_amount) END) 'interest_outstanding',
	SUM(CASE WHEN pm.`type` = 'penalty' THEN pm.amount - pm.paid_amount - (pm.refinance_amount + pm.void_amount) END) 'penalty_outstanding',
	SUM(CASE WHEN pm.due_date <= DATE(NOW()) THEN pm.amount END) 'total_amount_until_today',
	SUM(CASE WHEN pm.due_date <= DATE(NOW()) AND pm.`type` = 'principal' THEN pm.amount END) 'total_principal_amount_until_today',
	SUM(CASE WHEN pm.due_date <= DATE(NOW()) AND pm.`type` = 'interest' THEN pm.amount END) 'total_interest_amount_until_today',
	SUM(CASE WHEN pm.due_date <= DATE(NOW()) AND pm.`type` = 'penalty' THEN pm.amount END) 'total_penalty_amount_until_today',
	NULL 'total_paid_amount(14days_ago)', -- SUM(CASE WHEN pm.due_date >= DATE_ADD(date(now()), INTERVAL - 14 DAY) THEN pm.paid_amount END)
	NULL 'paid_principal(14days_ago)', -- SUM(CASE WHEN pm.due_date >= DATE_ADD(date(now()), INTERVAL - 14 DAY) AND pm.`type` = 'principal' THEN pm.paid_amount END)
	NULL 'paid_interest(14days_ago)', -- SUM(CASE WHEN pm.due_date >= DATE_ADD(date(now()), INTERVAL - 14 DAY) AND pm.`type` = 'interest' THEN pm.paid_amount END)
	NULL 'paid_penalty(14days_ago)', -- SUM(CASE WHEN pm.due_date >= DATE_ADD(date(now()), INTERVAL - 14 DAY) AND pm.`type` = 'penalty' THEN pm.paid_amount END)
	CASE WHEN c.status = 6 OR c.status = 7 THEN 0
		WHEN date(now()) >= p.last_payment_date THEN SUM(CASE WHEN pm.due_date BETWEEN DATE_ADD(p.last_payment_date, INTERVAL - 14 DAY) and p.last_payment_date THEN pm.amount END)
		ELSE IFNULL(SUM(CASE WHEN pm.due_date BETWEEN DATE_ADD(date(now()), INTERVAL - 14 DAY) AND date(now()) THEN pm.amount END), 0) 
	END 'total_amount_in_14days',
	NULL '%_of_paid_amount(14days_ago)', -- Morikawa request %
	CASE 
		WHEN DATE(NOW()) <= p.first_payment_date THEN 1
		WHEN c.status = 4 THEN ( SUM(pm.paid_amount) + SUM(pm.void_amount) + SUM(pm.refinance_amount) )/ SUM(CASE WHEN pm.due_date <= DATE(NOW()) THEN pm.amount END)
		WHEN c.status = 6 OR c.status = 7 THEN 1
		ELSE NULL
	END '%_of_paid_amount_until_today', 
	-- SUM(pm.paid_amount) , SUM(pm.void_amount), SUM(pm.refinance_amount), SUM(CASE WHEN pm.due_date <= DATE(NOW()) THEN pm.amount END), -- for checking
	CASE 
		WHEN DATE(NOW()) <= p.first_payment_date THEN 0
		WHEN c.status = 4 THEN (SUM(CASE WHEN pm.due_date <= DATE(NOW()) THEN pm.amount END) - SUM(pm.paid_amount)) / SUM(CASE WHEN pm.due_date <= DATE(NOW()) THEN pm.amount END)
		WHEN c.status = 6 OR c.status = 7 THEN 0
		ELSE NULL
	END '%_of_total_amount_outstanding',
	/*CASE WHEN c.status = 6 OR c.status = 7 THEN 'White'
		WHEN (SUM(pm.paid_amount) / SUM(CASE WHEN pm.due_date <= DATE(NOW()) THEN pm.amount END)) <= 0.1 THEN 'Black'
		WHEN (SUM(pm.paid_amount) / SUM(CASE WHEN pm.due_date <= DATE(NOW()) THEN pm.amount END)) < 0.8 THEN 'Grey'
		WHEN (SUM(pm.paid_amount) / SUM(CASE WHEN pm.due_date <= DATE(NOW()) THEN pm.amount END)) >= 0.8 THEN 'White'
		ELSE NULL 
	END 'collection_status'*/ -- this is the rule when customer paid >= 80% then get white
	/*CASE WHEN c.status = 6 OR c.status = 7 THEN 'White'
		WHEN SUM(CASE WHEN pm.due_date >= DATE_ADD(date(now()), INTERVAL - 14 DAY) THEN pm.paid_amount END) > 4 THEN 'White'
		WHEN SUM(CASE WHEN pm.due_date >= DATE_ADD(date(now()), INTERVAL - 30 DAY) THEN pm.paid_amount END) > 4 THEN 'Grey'
		WHEN (SUM(pm.paid_amount) / SUM(CASE WHEN pm.due_date <= DATE(NOW()) THEN pm.amount END)) > 0.3 THEN 'Grey'
		WHEN SUM(CASE WHEN pm.due_date >= DATE_ADD(date(now()), INTERVAL - 30 DAY) THEN pm.paid_amount END) <= 0 THEN 'Black'
		ELSE 'Black'
	END 'collection_status'*/ -- 
	CASE WHEN c.status = 6 OR c.status = 7 THEN 'White'
		-- WHEN p.initial_date >= '2021-12-01' THEN 'White' -- request from Morikawa on 2022-01-05
		WHEN DATEDIFF(DATE(NOW()),  p.first_payment_date) - 1 <= 10 THEN 'White'
		WHEN SUM(CASE WHEN pm.due_date >= DATE_ADD(date(now()), INTERVAL - 10 DAY) THEN pm.paid_amount END) > 4  THEN 'White'
		WHEN SUM(CASE WHEN pm.due_date >= DATE_ADD(date(now()), INTERVAL - 30 DAY) THEN pm.paid_amount END) > 4  THEN 'Grey'
		WHEN DATEDIFF(DATE(NOW()),  p.first_payment_date) - 1 <= 30 THEN 'Grey'
		WHEN (SUM(pm.paid_amount) / SUM(CASE WHEN pm.due_date <= DATE(NOW()) THEN pm.amount END)) > 0.3 THEN 'Grey' 
		WHEN DATEDIFF(DATE(NOW()),  p.first_payment_date) - 1 > 30 THEN 'Black'
		ELSE 'Black' 
	END 'collection_status'
from tblcontract c 
left join tblprospect p on (p.id = c.prospect_id)
left join tblpayment pm on (c.id = pm.contract_id)
where c.status in (4,6,7) and p.contract_type = 5 -- and p.id in (3168)
group by p.id ;





#============= AAA data to sheet daily_monitor ================
select c.contract_no , c.ncn , p.trading_currency , p.loan_amount ,
	SUM(CASE WHEN pm.due_date <= DATE(NOW()) THEN pm.amount - pm.paid_amount - (pm.refinance_amount + pm.void_amount) END) 'total_amount_until_today',
	count(CASE WHEN pm.due_date <= DATE(NOW()) AND pm.`type` = 'principal' and pm.status = 0 THEN 1 END) 'days_of_principal_until_today',
	SUM(CASE WHEN pm.due_date <= DATE(NOW()) AND pm.`type` = 'principal' THEN pm.amount - pm.paid_amount - (pm.refinance_amount + pm.void_amount) END) 'total_principal_amount_until_today',
	count(CASE WHEN pm.due_date <= DATE(NOW()) AND pm.`type` = 'interest' and pm.status = 0 THEN 1 END) 'days_of_interest_until_today',
	SUM(CASE WHEN pm.due_date <= DATE(NOW()) AND pm.`type` = 'interest' THEN pm.amount - pm.paid_amount - (pm.refinance_amount + pm.void_amount) END) 'total_interest_amount_until_today',
	count(CASE WHEN pm.due_date <= DATE(NOW()) AND pm.`type` = 'penalty' and pm.status = 0 THEN 1 END) 'days_of_penalty_until_today',
	SUM(CASE WHEN pm.due_date <= DATE(NOW()) AND pm.`type` = 'penalty' THEN pm.amount - pm.paid_amount - (pm.refinance_amount + pm.void_amount) END) 'total_penalty_amount_until_today',
	count(CASE WHEN pm.due_date <= DATE(NOW()) AND pm.`type` = 'principal' and pm.amount >0 and pm.status = 1 THEN 1 END) 'days_of_paid_principal',
	count(CASE WHEN pm.due_date <= DATE(NOW()) AND pm.`type` = 'interest' and pm.amount >0 and pm.status = 1 THEN 1 END) 'days_of_paid_interest',
	count(CASE WHEN pm.due_date <= DATE(NOW()) AND pm.`type` = 'penalty' and pm.amount >0 and pm.status = 1 THEN 1 END) 'days_of_paid_penalty',
	concat('https://moneymax.la/contract.php?contractid=', c.id) 'URL_to_LMS'
from tblcontract c 
left join tblprospect p on (p.id = c.prospect_id)
left join tblpayment pm on (c.id = pm.contract_id)
where c.status in (4) and p.contract_type = 5 -- and p.id in (3838)
group by p.id ;






#============ START Export customer and guarantor information to Yoshi and Paolor =============
SELECT 
	c.contract_no ,
	c.ncn ,
	p.customer_id ,
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_en , " ", cu.customer_last_name_en) using latin1) as binary) using utf8)customer_name_en,
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo , " ", cu.customer_last_name_lo) using latin1) as binary) using utf8)customer_name_en,
	case when left (right (REPLACE ( cu.main_contact_no, ' ', '') ,8),1) = '0' then CONCAT('03',right (REPLACE ( cu.main_contact_no, ' ', '') ,8))
	    when length (REPLACE ( cu.main_contact_no, ' ', '')) = 7 then CONCAT('030',REPLACE ( cu.main_contact_no, ' ', ''))
	    else CONCAT('020', right(REPLACE ( cu.main_contact_no, ' ', '') , 8))
	end `customer_contact_no`,
	case when left (right (REPLACE ( cu.sec_contact_no , ' ', '') ,8),1) = '0' then CONCAT('03',right (REPLACE ( cu.sec_contact_no, ' ', '') ,8))
	    when length (REPLACE ( cu.sec_contact_no, ' ', '')) = 7 then CONCAT('030',REPLACE ( cu.sec_contact_no, ' ', ''))
	    else CONCAT('020', right(REPLACE ( cu.sec_contact_no, ' ', '') , 8))
	end `customer_contact_no2`,
	CASE cu.address_province WHEN 1 THEN 'Attapue'
		WHEN 2 THEN 'Bokeo'
		WHEN 3 THEN 'Bolikhamxay'
		WHEN 4 THEN 'Champasak'
		WHEN 5 THEN 'Huaphan'
		WHEN 6 THEN 'Khammuane'
		WHEN 7 THEN 'Luangnamtha'
		WHEN 8 THEN 'Luangprabang'
		WHEN 9 THEN 'Oudomxay'
		WHEN 10 THEN 'Phongsaly'
		WHEN 11 THEN 'Salavanh'
		WHEN 12 THEN 'Savannakhet'
		WHEN 13 THEN 'Vientiane Capital'
		WHEN 14 THEN 'Vientiane Province'
		WHEN 15 THEN 'Xayabuly'
		WHEN 16 THEN 'Xaysomboun'
		WHEN 17 THEN 'Sekong'
		WHEN 18 THEN 'Xiengkhuang'
	END customer_province,
	cic.city_name 'customer_district_en',
	convert(cast(convert(cic.city_name_lao using latin1) as binary) using utf8) 'customer_district_lo',
	v.village_name 'customer_village_en',
	CASE WHEN cu.address_village_id != 0 THEN CONVERT(CAST(CONVERT(v.village_name_lao using latin1) as binary) using utf8)
		ELSE CONVERT(CAST(CONVERT(cu.address_village using latin1) as binary) using utf8) 
	END 'customer_village_lo',
	CONVERT(CAST(CONVERT(cu.occupation using latin1) as binary) using utf8) customer_occupation,
	CONVERT(CAST(CONVERT(cu.`position` using latin1) as binary) using utf8) customer_position,
	cu.work_no ,
	p.customer_monthly_income ,
	p.customer_monthly_expenditure ,
	p.customer_monthly_profit ,
	CONVERT(CAST(CONVERT(CONCAT(g.guarantor_first_name_en , " ", g.guarantor_last_name_en) using latin1) as binary) using utf8) guarantor_name_en,
	CONVERT(CAST(CONVERT(CONCAT(g.guarantor_first_name_lo , " ", g.guarantor_last_name_lo) using latin1) as binary) using utf8) guarantor_name_lo,
	case when left (right (REPLACE ( g.guarantor_contact_no , ' ', '') ,8),1) = '0' then CONCAT('03',right (REPLACE ( g.guarantor_contact_no, ' ', '') ,8))
	    when length (REPLACE ( g.guarantor_contact_no, ' ', '')) = 7 then CONCAT('030',REPLACE ( g.guarantor_contact_no, ' ', ''))
	    else CONCAT('020', right(REPLACE ( g.guarantor_contact_no, ' ', '') , 8))
	end `guarantor_contact_no`,
	CASE g.address_province WHEN 1 THEN 'Attapue'
		WHEN 2 THEN 'Bokeo'
		WHEN 3 THEN 'Bolikhamxay'
		WHEN 4 THEN 'Champasak'
		WHEN 5 THEN 'Huaphan'
		WHEN 6 THEN 'Khammuane'
		WHEN 7 THEN 'LuangNamtha'
		WHEN 8 THEN 'Luangprabang'
		WHEN 9 THEN 'Oudomxay'
		WHEN 10 THEN 'Phongsaly'
		WHEN 11 THEN 'Salavanh'
		WHEN 12 THEN 'Savannakhet'
		WHEN 13 THEN 'Vientiane Capital'
		WHEN 14 THEN 'Vientiane Province'
		WHEN 15 THEN 'Xayabuly'
		WHEN 16 THEN 'Xaysomboun'
		WHEN 17 THEN 'Sekong'
		WHEN 18 THEN 'Xiengkhuang'
		WHEN 19 THEN 'Xaysomboun'
	END guarantor_province,
	cig.city_name 'guarantor_district_en',
	convert(cast(convert(cig.city_name_lao using latin1) as binary) using utf8) 'guarantor_district_lo',
	vg.village_name  'guarantor_village_en',
	case when vg.village_name is null then CONVERT(CAST(CONVERT(g.address_village using latin1) as binary) using utf8) 
		else convert(cast(convert(vg.village_name_lao using latin1) as binary) using utf8) 
	end guarantor_village,
	CONVERT(CAST(CONVERT(g.guarantor_occupation using latin1) as binary) using utf8) guarantor_occupation,
	CONVERT(CAST(CONVERT(g.guarantor_position using latin1) as binary) using utf8) guarantor_position,
	g.guarantor_work_no ,
	g.guarantor_monthly_income ,
	g.guarantor_monthly_expenditure ,
	g.guarantor_monthly_profit ,
	case cv.automobile_types when 1 then 'Bike' when 2 then 'Car' when 3 then 'Truck' when 4 then 'Heavy equipment' else null
	end 'car_type',
	convert(cast(convert(concat(cv.maker, " ", cv.model) using latin1) as binary) using utf8) 'automobile',
	case cr.estate_types when 1 then 'Land' when 2 then 'Building' when 3 then 'Land and Building' else null
	end 'estate_type'
FROM tblcontract c LEFT JOIN tblguarantor g ON (c.prospect_id = g.prospect_id)
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
LEFT JOIN tblcustomer cu ON (cu.id = p.customer_id)
LEFT JOIN tblcity cic ON (cic.id = cu.address_city)
LEFT JOIN tblcity cig ON (cig.id = g.address_city)
LEFT JOIN tblvillage v ON (v.id = cu.address_village_id)
left join tblvillage vg on (vg.id = g.address_village)
left join tblcustomervehicles cv on (cu.id = cv.customer_id)
left join tblcustomerrealestate cr on (cr.customer_id = cu.id)
WHERE c.status in (4,6,7) and p.contract_type = 5 
ORDER BY p.id ;





#=============== Contract source on google sheet AAA Collection Report ================
SELECT 
	FROM_UNIXTIME(p.date_created, '%Y-%m-%d') Created_date,
	p.id 'contract no',
	c.ncn ,
	p.case_no,
	c.id 'contract id',
	p.initial_date 'contract date',
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo, " ", cu.customer_last_name_lo) using latin1) as binary) using utf8) Full_Name_LA,
	cu.main_Contact_no 'Tel1',
	p.trading_currency 'Currency',
	p.loan_amount,
	p.Fee,
	p.no_of_payment 'Time',
	p.refinance_id ,
	p.refinance_amount,
	p.net_payment_amount,
	p.first_payment_date ,
	p.last_payment_date ,
	A.payment_amount '1st payment amount', 
	A.principal_amount '1st principal', 
	A.interest_amount '1st interest', 
	B.payment_amount '2nd payment', 
	B.principal_amount '2nd principal', 
	B.interest_amount '2nd pricipal', 
	C.payment_amount 'last payment', 
	C.principal_amount 'last principal', 
	C.interest_amount 'last interest',
	CASE p.customer_profile WHEN 1 THEN 'New' WHEN 2 THEN 'Current customer' WHEN 3 THEN 'Dormant customer' END Customer_Type,
	CASE p.payment_schedule_type WHEN 1 THEN 'Installment' WHEN 2 THEN 'One-time' ELSE NULL END 'Payment_Method',
	case p.contract_type when 1 then 'SME Car' when 2 then 'SME Bike' when 3 then 'Car Leasing' when 4 then 'Bike Leasing'
		when 5 then 'Micro Leasing' when 6 then 'Cash Lao' when 7 then 'Quick Loan' when 8 then 'Money Lao' else null
	end 'contract type',
	CASE
		p.status WHEN 0 THEN 'Draft'
		WHEN 1 THEN 'Pending Approval from Credit'
		WHEN 2 THEN 'Pending Final Approval from Credit Manager'
		WHEN 3 THEN 'Approved'
		WHEN 4 THEN 'Cancelled'
		ELSE NULL
	END Prospect_status,
	CASE
		c.status WHEN 0 THEN 'Pending'
		WHEN 1 THEN 'Pending Approval'
		WHEN 2 THEN 'Pending Disbursement'
		WHEN 3 THEN 'Disbursement Approval'
		WHEN 4 THEN 'Active'
		WHEN 5 THEN 'Cancelled'
		WHEN 6 THEN 'Refinance'
		WHEN 7 THEN 'Closed'
		ELSE NULL
	END Contract_status,
	case when FROM_UNIXTIME(c.disbursed_datetime , '%Y-%m-%d') = '1970-01-01' then c.contract_date
		else FROM_UNIXTIME(c.disbursed_datetime , '%Y-%m-%d')
	end 'disbursed_datetime',
	case p.call_centre 
		when 1 then 'Head Office'
		when 2 then 'Savannakhet'
		when 3 then 'Champasak'
		when 4 then 'Luangprabang'
		when 5 then 'Oudomxay'
		when 6 then 'Vientiane province'
		when 7 then 'Xeno'
		when 8 then 'Soukumma'
		when 9 then 'Xayyabouly'
		when 10 then 'Hauphan'
		when 11 then 'Xiengkuang'
		when 12 then 'Bolikhamxay'
		when 13 then 'Paksong - SVK'
		when 14 then 'Thakhek khammuan'
		when 15 then 'Salavan'
		when 16 then 'Attapeu'
		when 17 then 'Kham'
		when 18 then 'Phin'
		when 21 then 'Other'
		when 22 then 'Luangnamtha'
		when 24 then 'Dongdok - Vientiane Capital'
		when 26 then 'Vangvieng - Vientiane province'
		when 27 then 'Bokeo'
		when 28 then 'Phongsaly'
		when 29 then 'Sekong'
		when 30 then 'Xaysomboun'
	end Branch,
	u1.staff_no 'salesperson_no', u1.nickname 'salesperson',
	-- u3.staff_no 'current_salesperson_no', u3.nickname 'current_salesperson',
	CONCAT(u2.staff_no , " - ", u2.nickname) 'created by user',
	c.date_closed 
FROM tblprospect p
LEFT JOIN tbluser u1 ON (p.salesperson_id = u1.id)
LEFT JOIN tbluser u2 ON (p.created_by_user_id = u2.id)
left join tbluser u3 on (p.current_salesperson_id = u3.id)
LEFT JOIN tblcustomer cu ON (p.customer_id = cu.id)
LEFT JOIN tblcontract c ON (p.id = c.prospect_id)
LEFT JOIN tblpaymentschedule A ON A.id = (select id from tblpaymentschedule where contract_id=c.id and payment_amount != 0 order by payment_date limit 1)
LEFT JOIN tblpaymentschedule B ON B.id = (select id from tblpaymentschedule where contract_id=c.id and payment_amount != 0 order by payment_date limit 1, 1)
LEFT JOIN tblpaymentschedule C ON C.id = (select id from tblpaymentschedule where contract_id=c.id and payment_amount != 0 order by payment_date desc limit 1)
WHERE p.contract_type = 5 ;




#============ START Check collection payment for Sack 43 Collection AAA collection payment sheet daily_report ===========
SELECT 
	c.contract_no ,
	p.first_payment_date ,
	p.last_payment_date ,
	ps.payment_date 'date_already_paid',
	p.no_of_payment ,
	DATEDIFF(ps.payment_date, p.first_payment_date - 1) 'no_of_already_paid' ,
	CASE WHEN c.status = 6 OR c.status = 7 THEN 0 
		WHEN p.first_payment_date >= DATE(NOW()) or ps.payment_date >= DATE(NOW()) THEN 0
		WHEN c.status = 4 THEN DATEDIFF(DATE(NOW()), ps.payment_date ) 
	END 'delay_days_after_date_already_paid' ,
	CASE WHEN c.status = 6 OR c.status = 7 or p.last_payment_date >= DATE(NOW()) THEN 0 
		WHEN c.status = 4 THEN DATEDIFF(DATE(NOW()), p.last_payment_date ) 
	END 'delay_days_after_last_payment_date' ,
	CASE WHEN c.status = 6 THEN 'already paid' WHEN c.status = 7 THEN 'already paid'
		WHEN DATEDIFF(DATE(NOW()),  p.first_payment_date) < 1 THEN 'already paid'
		WHEN DATEDIFF(DATE(NOW()),  p.first_payment_date) >= 1 THEN 'not paid'
		WHEN DATEDIFF(DATE(NOW()),  ps.payment_date) <= 1 THEN 'already paid'
		WHEN DATEDIFF(DATE(NOW()),  ps.payment_date) > 1 THEN 'not paid'
		ELSE NULL
	END 'payment_status',
	CASE c.status WHEN 0 THEN 'Pending' WHEN 1 THEN 'Pending Approval' WHEN 2 THEN 'Pending Disbursement' WHEN 3 THEN 'Disbursement Approval'
		WHEN 4 THEN 'Active' WHEN 5 THEN 'Cancelled' WHEN 6 THEN 'Refinance' WHEN 7 THEN 'Closed' ELSE NULL
	END contract_status
FROM tblcontract c
LEFT JOIN tblprospect p ON (c.prospect_id = p.id)
LEFT JOIN tblpaymentschedule ps ON ps.id = (SELECT id FROM tblpaymentschedule WHERE status = 1 and payment_amount !=0 and contract_id = c.id ORDER BY payment_date DESC LIMIT 1)
WHERE p.contract_type in (6,7,8) and c.status in (4,6,7) -- and p.id in (3168)
GROUP BY c.prospect_id;



