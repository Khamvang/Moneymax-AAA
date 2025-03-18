

#=========== Cash lao: Tik requests to check the payment of each customer every month =========
SELECT 
	case p.contract_type when 1 then 'SME Car' when 2 then 'SME Bike' when 3 then 'Car Leasing' when 4 then 'Bike Leasing'
		when 5 then 'Micro Leasing' when 6 then 'Cash Lao' when 7 then 'Quick Loan' when 8 then 'Money Lao' else null
	end 'contract type',
	c.contract_no , c.ncn , c.contract_date , p.trading_currency , p.loan_amount ,
	CASE c.status WHEN 0 THEN 'Pending' WHEN 1 THEN 'Pending Approval' WHEN 2 THEN 'Pending Disbursement' WHEN 3 THEN 'Disbursement Approval'
		WHEN 4 THEN 'Active' WHEN 5 THEN 'Cancelled' WHEN 6 THEN 'Refinance' WHEN 7 THEN 'Closed' ELSE NULL
	END contract_status,
	p.no_of_payment , 
	CASE p.payment_schedule_type WHEN 1 THEN 'Installment' WHEN 2 THEN 'One-time' ELSE NULL end `payment_type`, 
	cu.id 'customer_id',
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo , " ",cu.customer_last_name_lo ) using latin1) as binary) using utf8) 'customer_full_name_lo',
	cu.main_contact_no 'customer_tel1',
	concat(us.staff_no," - ", us.nickname) 'salesperson',
	NULL 'current_salesperson',
	SUM(CASE WHEN co.date_collected between '2022-01-01' and '2022-01-31' and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-01',
	SUM(CASE WHEN co.date_collected between '2022-02-01' and '2022-02-28' and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-02',
	SUM(CASE WHEN co.date_collected between '2022-03-01' and '2022-03-31' and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-03',
	SUM(CASE WHEN co.date_collected between '2022-04-01' and '2022-04-30' and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-04',
	SUM(CASE WHEN co.date_collected between '2022-05-01' and '2022-05-31' and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-05',
	SUM(CASE WHEN co.date_collected between '2022-06-01' and '2022-06-30' and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-06',
	SUM(CASE WHEN co.date_collected between '2022-07-01' and '2022-07-31' and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-07',
	SUM(CASE WHEN co.date_collected between '2022-08-01' and '2022-08-31' and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-08',
	SUM(CASE WHEN co.date_collected between '2022-09-01' and '2022-09-30' and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-09',
	SUM(CASE WHEN co.date_collected between '2022-10-01' and '2022-10-31' and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-10',
	SUM(CASE WHEN co.date_collected between '2022-11-01' and '2022-11-30' and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-11',
	SUM(CASE WHEN co.date_collected between '2022-12-01' and '2022-12-31' and (co.status = 1 or co.payment_amount = 0) THEN co.payment_amount END) '2022-12',
SUM(CASE WHEN co.status = 1 or co.payment_amount = 0 THEN co.payment_amount END) 'total_paid_amount',
SUM(CASE WHEN co.status = 1 or co.payment_amount = 0 THEN co.principal_payment_amount END) 'paid_principal',
SUM(CASE WHEN co.status = 1 or co.payment_amount = 0 THEN co.interest_payment_amount END) 'paid_interest',
SUM(CASE WHEN co.status = 1 or co.payment_amount = 0 THEN co.penalty_payment_amount END) 'paid_penalty',
	NOW() 'datetime_updated' 
FROM tblcontract c 
LEFT JOIN tblcollection co ON (c.id = co.contract_id)
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
left join tblcustomer cu on (cu.id = p.customer_id)
left join tbluser us on (us.id = p.salesperson_id)
left join tbluser uc on (uc.id = p.current_salesperson_id)
WHERE p.contract_type in (6,7,8) and c.status in (4,6,7) -- and co.status = 1
group by c.contract_no 
order by c.contract_no desc;


