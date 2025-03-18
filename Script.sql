#Prospect list in Money max system for Yamanaka
SELECT 
	FROM_UNIXTIME(p.date_created, '%Y-%m-%d') Created_date,
	p.id 'contract no',
	null ncn ,
	p.case_no,
	c.id 'contract id',
	p.initial_date 'contract date',
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_en, " ", cu.customer_last_name_en) using latin1) as binary) using utf8) Full_Name_En,
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo, " ", cu.customer_last_name_lo) using latin1) as binary) using utf8) Full_Name_LA,
	cu.Main_Contact_no 'Tel1',
	cu.Sec_Contact_no 'Tel2',
	CONVERT(CAST(CONVERT(cu.occupation using latin1) as binary) using utf8) 'occupation',
	CONVERT(CAST(CONVERT(cu.occupation using latin1) as binary) using utf8) 'occupation_en',
	CONVERT(CAST(CONVERT(cu.`position` using latin1) as binary) using utf8) 'posstion',
	CONVERT(CAST(CONVERT(cu.`position` using latin1) as binary) using utf8) 'posstion_en',
	p.Trading_currency 'Currency',
	p.Loan_amount,
	p.Fee,
	p.no_of_payment 'Time',
	p.refinance_id ,
	p.Refinance_amount,
	p.Net_payment_amount,
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
	CASE
		p.customer_profile WHEN 1 THEN 'New'
		WHEN 2 THEN 'Current customer'
		WHEN 3 THEN 'Dormant customer'
	END Customer_Type,
	CASE
		p.payment_schedule_type WHEN 1 THEN 'Installment'
		WHEN 2 THEN 'One-time'
		ELSE NULL
	END 'Payment_Method',
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
	CONCAT(u1.staff_no, " - ", u1.nickname) 'Sales person',
	CONCAT(u2.staff_no , " - ", u2.nickname) 'created by user'
FROM tblprospect p
LEFT JOIN tbluser u1 ON (p.salesperson_id = u1.id)
LEFT JOIN tbluser u2 ON (p.created_by_user_id = u2.id)
LEFT JOIN tblcustomer cu ON (p.customer_id = cu.id)
LEFT JOIN tblcontract c ON (p.id = c.prospect_id)
LEFT JOIN tblpaymentschedule A ON A.id = (select id from tblpaymentschedule where contract_id=c.id and payment_amount != 0 order by payment_date limit 1)
LEFT JOIN tblpaymentschedule B ON B.id = (select id from tblpaymentschedule where contract_id=c.id and payment_amount != 0 order by payment_date limit 1, 1)
LEFT JOIN tblpaymentschedule C ON C.id = (select id from tblpaymentschedule where contract_id=c.id and payment_amount != 0 order by payment_date desc limit 1)
WHERE p.contract_type = 5; -- and p.customer_profile = 1 and p.initial_date BETWEEN '2021-10-01' and '2021-10-14' and c.status = 4;


#Check loan data
SELECT p.id, p.customer_id , p.case_no , p.initial_date , p.first_payment_date , p.last_payment_date , p.loan_amount , p.no_of_payment , u.staff_no 
FROM tblprospect p LEFT JOIN tbluser u ON (p.salesperson_id = u.id);

#Checking and update refinance id with Sameera Ticket Feature #732 and source on live sheet on my google sheet
SELECT
	p.id 'prospect_id',
	c.id 'contract id',
	p.refinance_id ,
	c.ncn ,
	p.initial_date ,
	c.contract_date ,
	p.first_payment_date ,
	p.last_payment_date ,
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_en, " ", cu.customer_last_name_en) using latin1) as binary) using utf8) Full_Name_En,
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo, " ", cu.customer_last_name_lo) using latin1) as binary) using utf8) Full_Name_LA,
	cu.main_contact_no ,
	case p.contract_type when 1 then 'SME Car' when 2 then 'SME Bike' when 3 then 'Car Leasing' when 4 then 'Bike Leasing'
		when 5 then 'Micro Leasing' when 6 then 'Cash Lao' when 7 then 'Quick Loan' when 8 then 'Money Lao' else null
	end 'contract type',
	CASE p.no_of_payment WHEN 105 THEN 'no collect holidays and weekend'
		ELSE 'collect every days'
	END `payment_type`,
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
	c.date_closed 
FROM tblprospect p
LEFT JOIN tblcontract c ON (p.id = c.prospect_id)
LEFT JOIN tblcustomer cu ON (p.customer_id = cu.id)
WHERE p.contract_type = 5 -- and p.id in (739)
ORDER BY p.id;

#============ Yoshi request to make the collection report to follow AAA contract ===============
select 
	c.contract_no ,
	co.id `collection_id`,
	co.date_collected ,
	co.payment_amount ,
	co.usd_amount ,
	co.thb_amount ,
	co.lak_amount ,
	co.collection_method ,
	co.bank_usd_amount ,
	co.bank_thb_amount ,
	co.bank_lak_amount 
from tblcollection co 
left join tblcontract c on (c.id = co.contract_id)
left join tblprospect p on (p.id = c.prospect_id)
where p.contract_type = 5 and co.status = 1 -- and co.date_collected >= '2021-10-01'

SELECT COUNT(*) FROM tblcollection t -- where status = 1;

#Collection report of staff Requested from AAA staff
SELECT 
	co.date_collected ,
	c.contract_no ,
	c.ncn ,
	CONVERT (CAST(CONVERT(CONCAT(cu.customer_first_name_en, " ", cu.customer_last_name_en) using latin1) as binary) using utf8) 'full name en',
	CONVERT (CAST(CONVERT(CONCAT(cu.customer_first_name_lo , " ", cu.customer_last_name_lo) using latin1) as binary) using utf8) 'full name lo',
	cu.main_contact_no ,
	co.lak_amount ,
	co.usd_amount ,
	co.thb_amount ,
	ROUND( (co.lak_amount * cur.lak2usd) + co.usd_amount + (co.thb_amount * cur.thb2usd),2) 'total in USD'
FROM tblcollection co 
LEFT JOIN tblcontract c ON (c.id = co.contract_id)
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
LEFT JOIN tblcustomer cu ON (cu.id = p.customer_id)
LEFT JOIN tbluser u ON (u.id = co.personcollect_id)
LEFT JOIN tblcurrencyrate cur ON (co.date_collected = cur.date_for)
WHERE co.date_collected = '2021-02-18' and co.banktransfer_id = 0;

#Checking payment that have not cleared
SELECT 
	c.contract_no ,
	c.ncn,
	pay.due_date ,
	pay.`type` ,
	pay.amount - pay.paid_amount 'Pending'
FROM tblcontract c 
LEFT JOIN tblpayment pay ON (c.id = pay.contract_id)
WHERE pay.amount - pay.paid_amount != 0  and pay.due_date <= '2021-03-09';

#check payment amount with detail
SELECT 
	c.contract_no ,
	c.ncn ,
	c.id 'contract id',
	p.loan_amount ,
	p.trading_currency ,
	col.accrual_payment_amount ,
	col.penalty_payment_amount ,
	col.interest_payment_amount ,
	col.principal_payment_amount ,
	col.payment_amount ,
	col.date_collected ,
	col.usd_amount + col.bank_usd_amount as "USD",
	col.lak_amount + col.bank_lak_amount as "LAK",
	col.thb_amount + col.bank_thb_amount as "THB",
	CASE col.status WHEN -1 THEN 'Draft'
		WHEN 0 THEN 'Pending'
		WHEN 1 THEN 'Approved'
		WHEN 2 THEN 'Rejected'
		ELSE ''
	END 'collection_status'
FROM tblcontract c 
LEFT JOIN tblcollection col ON (c.id = col.contract_id)
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
WHERE p.contract_type = 5
ORDER BY c.prospect_id , col.date_collected ;

#check total payment amount of each contracts
SELECT 
	c.contract_no , 
	c.ncn ,
	c.id ,
	case p.contract_type when 1 then 'SME Car' when 2 then 'SME Bike' when 3 then 'Car Leasing' when 4 then 'Bike Leasing'
		when 5 then 'Micro Leasing' when 6 then 'Cash Lao' when 7 then 'Quick Loan' when 8 then 'Money Lao' else null
	end 'contract type',
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
	col.accrual_payment_amount ,
	col.payment_amount ,
	SUM( col.usd_amount) + SUM( col.bank_usd_amount) as "USD",
	SUM(col.lak_amount) + SUM(col.bank_lak_amount) as "LAK",
	SUM(col.thb_amount) + SUM(col.bank_thb_amount) as "THB" 
FROM tblcontract c 
LEFT JOIN tblcollection col ON (c.id = col.contract_id)
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
GROUP BY c.contract_no ;

#Checking all penalties amount of each contracts detail with each due date
SELECT 
	p.id 'contract no',
	c.id 'contract id',
	case p.contract_type when 1 then 'SME Car' when 2 then 'SME Bike' when 3 then 'Car Leasing' when 4 then 'Bike Leasing'
		when 5 then 'Micro Leasing' when 6 then 'Cash Lao' when 7 then 'Quick Loan' when 8 then 'Money Lao' else null
	end 'contract type',
	p.loan_amount ,
	p.trading_currency ,
	pay.due_date ,
	pay.`type` ,
	pay.amount ,
	pay.amount/p.loan_amount 'penalty rate'
FROM tblpayment pay
LEFT JOIN tblcontract c ON (c.id = pay.contract_id)
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
WHERE p.contract_type = 5 and pay.`type` = 'penalty' -- and pay.amount/p.loan_amount != 0.002;

#Check penalties group by contract no
SELECT 
	p.id 'contract no',
	c.id 'contract id',
	case p.contract_type when 1 then 'SME Car' when 2 then 'SME Bike' when 3 then 'Car Leasing' when 4 then 'Bike Leasing'
		when 5 then 'Micro Leasing' when 6 then 'Cash Lao' when 7 then 'Quick Loan' when 8 then 'Money Lao' else null
	end 'contract type',
	p.loan_amount ,
	p.trading_currency ,
	pay.`type` ,
	pay.amount ,
	pay.amount/p.loan_amount 'penalty rate'
FROM tblpayment pay
LEFT JOIN tblcontract c ON (c.id = pay.contract_id)
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
WHERE p.contract_type = 5 and pay.`type` = 'penalty' -- and pay.amount/p.loan_amount != 0.002
GROUP BY p.id;

SELECT 
	id,
	refinance_id 
FROM tblprospect 
WHERE id = 972

 -- 
SELECT * FROM tblcollection WHERE contract_id = 129;
SELECT * FROM tblpayment WHERE contract_id = 129;

#Checking payment amount for refinance
SELECT 
	c.contract_no ,
	c.ncn ,
	pay.`type` ,
	pay.due_date ,
	pay.amount ,
	pay.paid_amount ,
	pay.status 
FROM tblpayment pay
LEFT JOIN tblcontract c ON (c.id = pay.contract_id)
WHERE  c.id = 806
ORDER BY pay.due_date ,
FIELD(pay.`type`, "penalty", "interest", "principal");

#Checking refinance on prospect
SELECT 
	p.id,
	p.customer_id ,
	p.case_no ,
	p.refinance_id ,
	p.refinance_amount 
FROM tblprospect p
WHERE p.refinance_id = 354;

#Checking collection before fix for refinance 
SELECT c.prospect_id 'contract no', c.ncn ,
	col.date_collected ,
	col.payment_amount ,
	col.usd_amount + col.bank_usd_amount as "USD",
	col.lak_amount+ col.bank_lak_amount as "LAK",
	col.thb_amount + col.bank_thb_amount as "THB" ,
	CONCAT(u.staff_no, " ", u.nickname) 'approved by',
	col.status ,
	p.loan_amount ,
	p.trading_currency ,
	col.id 'collection id'
FROM tblcollection col LEFT JOIN tblcontract c ON (c.id = col.contract_id)
LEFT JOIN tbluser u ON (u.id = col.approve_by_staff_id)
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
where contract_id = 547;

#============ Collection schedule [Check payemnt and penalty] Sameera and Nun 1603 ===========
SELECT 
	c.contract_no ,
	c.ncn ,
	c.id 'contract_id',
	pay.due_date ,
	pay.amount ,
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
	END Contract_status,
	pay.`type` ,
	case p.contract_type when 1 then 'SME Car' when 2 then 'SME Bike' when 3 then 'Car Leasing' when 4 then 'Bike Leasing'
		when 5 then 'Micro Leasing' when 6 then 'Cash Lao' when 7 then 'Quick Loan' when 8 then 'Money Lao' else null
	end 'contract type'
FROM tblpayment pay
LEFT JOIN tblcontract c ON (c.id = pay.contract_id)
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
WHERE c.status = 4 and p.contract_type = 5  and pay.`type` != 'penalty'
ORDER BY c.contract_no , pay.due_date ,
FIELD(pay.`type`, "penalty", "interest", "principal");


SELECT * from tblpayment t where contract_id = 458 and schedule_id = 217917;
select * from tblpaymentschedule t where id = 217917

SELECT `type` , COUNT(*) , SUM(amount)  from tblpayment t where contract_id = 1186 GROUP by `type` ;

SELECT loan_amount - refinance_amount - fee 'Net mount' FROM tblprospect WHERE id = 630;
SELECT net_payment_amount FROM tblprospect WHERE id = 630;

#Checking refinance amount P and I
SELECT SUM(amount) - SUM( paid_amount) FROM tblpayment where contract_id = 354 and `type` = 'principal' and status = 0;
SELECT SUM(amount) - SUM( paid_amount) FROM tblpayment where contract_id = 354 and `type` = 'interest' and status = 0 and due_date <= '2021-03-23';
SELECT SUM( paid_amount) FROM tblpayment where contract_id = 354 and `type` = 'principal' -- and status = 0;

#Check term or time of payment table 
SELECT 
	c.prospect_id 'contract no',
	c.ncn ,
	c.id,
	COUNT(pay.`type`) ,
	case p.contract_type when 1 then 'SME Car' when 2 then 'SME Bike' when 3 then 'Car Leasing' when 4 then 'Bike Leasing'
		when 5 then 'Micro Leasing' when 6 then 'Cash Lao' when 7 then 'Quick Loan' when 8 then 'Money Lao' else null
	end 'contract type'
FROM tblpayment pay
LEFT JOIN tblcontract c ON (c.id = pay.contract_id)
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
WHERE pay.`type` = 'principal' and p.id = 642
GROUP BY c.prospect_id ;

#Check prospect case no
SELECT id,customer_id , case_no, FROM_UNIXTIME(date_created, '%Y-%m-%d %H:%m:%s')  FROM tblprospect WHERE customer_id = 278;
#Update prospect case no
UPDATE tblprospect SET case_no = '278-1' WHERE id = 255 and case_no '278-3';
UPDATE tblprospect SET case_no = '278-2' WHERE id = 636 and case_no '278-1';
UPDATE tblprospect SET case_no = '278-3' WHERE id = 637 and case_no '278-4';
UPDATE tblprospect SET case_no = '278-4' WHERE id = 989 and case_no '278-2';
#Update last payment date in tblprospect 
SELECT * FROM tblprospect WHERE id = 1909;
UPDATE tblprospect SET last_payment_date = '2021-08-10' WHERE id = 1909 and last_payment_date = '2021-08-09';

#Update contract status 
SELECT prospect_id, id, status FROM tblcontract WHERE id = 386 and prospect_id = 403;
UPDATE tblcontract SET status = 5 WHERE id = 386 and status = 4;

#Update tranding currency
SELECT * FROM tblprospect WHERE id = 813;
UPDATE tblprospect SET trading_currency = 'USD' WHERE id = 813 and trading_currency = 'THB';

#Check Bank statement status before update
SELECT * FROM tblbankstatement WHERE id = 2958 ;
SELECT * FROM tblcollection WHERE banktransfer_id = 2958 ;
SELECT * FROM tblrefinancebanktransfer WHERE banktransfer_id = 2958 ;
#Update bank statement status (0 = new, 1 = pending, 2 = Allocated, 3 = Removed, 4 = Oracle Reversed)
UPDATE tblbankstatement SET status = 0 , allocate_amount = 0 WHERE id = 2958  and  status = 2 and allocate_amount = 233000.00;

#Update datetime transfer in table bank statement and collection with one case
-- select to check
SELECT b.id, b.reference_no, FROM_UNIXTIME(b.transfer_datetime,'%Y-%m-%d %H:%m:%s') 'now_transfer_datetime', RIGHT(b.description,19) 'correct_transfer_datetime', 
	b.transfer_datetime ,	UNIX_TIMESTAMP('2021-10-10 20:38:02'), co.transfer_date , co.date_collected 
FROM tblbankstatement b left join tblcollection co on (b.id = co.banktransfer_id)
WHERE b.id = 6261;
-- update 
UPDATE tblbankstatement b left join tblcollection co on (b.id = co.banktransfer_id) 
SET b.transfer_datetime = UNIX_TIMESTAMP('2021-10-10 20:38:02') , co.transfer_date = '2021-10-10' , co.date_collected = '2021-10-10'
WHERE b.id = 6261; 

#Check prospect 
SELECT * FROM tblprospect  WHERE initial_date = '0000-00-00' and status = 3;

#The contracts that active but in prospect not approved (prospect draft).
SELECT 
	p.id 'prospect id',
	c.id 'contract id',
	p.case_no ,
	p.status 'prospect status',
	c.status 'contract status'
FROM tblcontract c 
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
WHERE p.status <> 3 and (c.status = 4 or c.status = 6 or c.status = 7 );
UPDATE tblprospect SET status = 3 WHERE id = 2332 and status = 1;

#Checking contract status that requested from Muay
SELECT 
	p.id 'prospect id',
	c.id 'contract id',
	p.case_no ,
	p.status 'prospect status',
	c.status 'contract status',
	FROM_UNIXTIME( p.date_created , '%Y-%m-%d') 'date created',
	CONCAT( u1.staff_no , " ", u1.nickname ) 'sales person',
	CONCAT( u2.staff_no , " ", u2.nickname ) 'created by'
FROM tblcontract c 
RIGHT JOIN tblprospect p ON (p.id = c.prospect_id)
LEFT JOIN tbluser u1 ON (u1.id = p.salesperson_id)
LEFT JOIN tbluser u2 ON (u2.id = p.created_by_user_id)
WHERE p.id in (1344,1396,1413,1513);
#Checking payment schedule 
SELECT * FROM tblpaymentschedule WHERE prospect_id = 642; -- in (1344,1396,1413,1513) ORDER BY prospect_id ;
#Checking for update Schedule Ticket 809 Sameera and Harshana
SELECT 
	p.id 'prospect id',
	c.id 'contract id',
	p.initial_date ,
	p.last_payment_date ,
	p.case_no ,
	A.payment_amount '1st payment amount', 
	A.principal_amount '1st principal', 
	A.interest_amount '1st interest', 
	B.payment_amount '2nd payment', 
	B.principal_amount '2nd principal', 
	B.interest_amount '2nd pricipal', 
	C.payment_amount 'last payment', 
	C.principal_amount 'last principal', 
	C.interest_amount 'last interest',
	p.status 'prospect status',
	c.status 'contract status'
FROM tblcontract c 
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
LEFT JOIN tblpaymentschedule A ON A.id = (select id from tblpaymentschedule where contract_id=c.id order by payment_date limit 1)
LEFT JOIN tblpaymentschedule B ON B.id = (select id from tblpaymentschedule where contract_id=c.id order by payment_date limit 1, 1)
LEFT JOIN tblpaymentschedule C ON C.id = (select id from tblpaymentschedule where contract_id=c.id order by payment_date desc limit 1)
WHERE p.id = 1353;


#All contract from broker export for Yamanaka and Viet
SELECT
	c.contract_no ,
	c.ncn,
	p.case_no ,
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo , " ",cu.customer_last_name_lo ) using latin1) as binary) using utf8) Cus_name_la,
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_en , " ",cu.customer_last_name_en ) using latin1) as binary) using utf8) Cus_name_en,
	cu.main_contact_no as Cus_tel ,
    p.loan_amount ,
    CASE
        p.customer_profile WHEN 1 THEN 'New'
        WHEN 2 THEN 'Current'
        WHEN 3 THEN 'Dormant'
        ELSE NULL
    END Cus_type ,
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
	case p.contract_type when 1 then 'SME Car' when 2 then 'SME Bike' when 3 then 'Car Leasing' when 4 then 'Bike Leasing'
		when 5 then 'Micro Leasing' when 6 then 'Cash Lao' when 7 then 'Quick Loan' when 8 then 'Money Lao' else null
	end 'contract type',
    p.broker_id ,
    CONVERT(CAST(CONVERT(CONCAT(b.first_name , " ",b.last_name ) using latin1) as binary) using utf8) Broker_name,
	b.contact_no as Broker_tel,
	p.broker_commission ,
	u.staff_no ,
	u.nickname  ,
	u.department 'sales/cc',
	FROM_UNIXTIME(c.disbursed_datetime , '%Y-%m-%d') 'disbursed date'
FROM tblcontract c
LEFT JOIN tblprospect p ON (c.prospect_id = p.id)
LEFT JOIN tblcustomer cu ON (cu.id = p.customer_id)
RIGHT JOIN tblbroker b ON (b.id = p.broker_id)
LEFT JOIN tbluser u ON (u.id = p.salesperson_id)
WHERE c.status in (4,6,7) AND p.broker_id <> 0 and p.contract_type = 5
Order by c.disbursed_datetime desc;

#Check and update accrual interest 
SELECT id, case_no , loan_amount , initial_date , accrual_interest_payment FROM tblprospect WHERE id = 1930;
UPDATE tblprospect SET accrual_interest_payment = 11.46 WHERE id = 1930 and accrual_interest_payment = 0;
-- Check all contract that interest rate is not 3 and 9
SELECT 
	id 'prospect id',
	case_no ,
	loan_amount ,
	no_of_payment ,
	monthly_interest 
FROM tblprospect
WHERE contract_type = 5;
#Check and update last payment date
SELECT id, case_no , initial_date , first_payment_date , no_of_payment , last_payment_date FROM tblprospect  WHERE case_no = '576-3';
UPDATE tblprospect SET last_payment_date = '2021-07-30' WHERE id = 1824 and last_payment_date = '2021-07-27';
#Feature #657 moneymax update contract
SELECT 
	p.id, 
	p.customer_id ,
	p.case_no ,
	p.initial_date ,
	p.first_payment_date ,
	p.last_payment_date ,
	p.loan_amount ,
	p.no_of_payment ,
	u.staff_no 
FROM tblprospect p
LEFT JOIN tbluser u ON (p.salesperson_id = u.id);


SELECT * from tbluser where id = 11129;

#Checking the person who approved collection and who created collection by collection id 
SELECT col.id , col.date_collected , col.payment_amount, FROM_UNIXTIME(col.approve_datetime, '%Y-%m-%d %H:%m:%s') 'Approved datetime', 
CONCAT(u1.staff_no ," ", u1.nickname ) 'approved by', CONCAT(u2.staff_no ," ", u2.nickname ) 'approved by'  
FROM tblcollection col LEFT JOIN tbluser u1 ON (u1.id = col.approve_by_staff_id) LEFT JOIN tbluser u2 ON (u2.id = created_by_user_id)
WHERE col.id = 161354;

SELECT * from tblprospect t where last_payment_date <= '2021-05-31' and contract_type = 5;
SELECT * FROM tblcollection WHERE id = 64273 or id =71452;
SELECT DISTINCT status FROM tblcollection t ;
#Check the collectio status for update (issue is account can't approved on live)
SELECT * FROM tblcollection t where id = 71358;
SELECT c.prospect_id , col.id 'collection id', col.payment_amount , col.status , col.account_approval_status , c.status 
FROM tblcollection col left join tblcontract c on (c.id = col.contract_id) where col.status = 0 and c.status = 4;
UPDATE tblcollection SET status = 1 WHERE status = 0 and account_approval_status = 0;

#Chairman request to export all Ringi 
SELECT 
	FROM_UNIXTIME(p.date_created,'%Y-%m-%d') 'date_created' ,
	p.id 'prospect_id',
	cu.id 'customer_id',
	case p.contract_type when 1 then 'SME Car' when 2 then 'SME Bike' when 3 then 'Car Leasing' when 4 then 'Bike Leasing'
		when 5 then 'Micro Leasing' when 6 then 'Cash Lao' when 7 then 'Quick Loan' when 8 then 'Money Lao' else null
	end 'contract type',
	p.loan_amount ,
	p.trading_currency ,
	p.initial_date ,
	p.no_of_payment ,
	p.last_payment_date ,
	CONVERT(CAST(CONVERT( p.fund_objective using latin1) as binary) using utf8) 'fund_objective',
	CONVERT(CAST(CONVERT( p.repayment_source using latin1) as binary) using utf8) 'repayment_source',
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_en , " ",cu.customer_last_name_en ) using latin1) as binary) using utf8) 'customer_full_name_en',
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo , " ",cu.customer_last_name_lo ) using latin1) as binary) using utf8) 'customer_full_name_lo',
	cu.main_contact_no 'customer_tel1',
	cu.sec_contact_no 'customer_tel2',
	CONCAT( DATE_FORMAT(DATE(NOW()),'%Y') - DATE_FORMAT(cu.date_of_birth,'%Y')," ", 'years old') 'customer_age' ,
	CASE
		cu.address_province WHEN 1 THEN 'Attapue'
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
	END 'address_province)',
	CONVERT(CAST(CONVERT(cu.address_village using latin1) as binary) using utf8) 'village',
	CONVERT(CAST(CONVERT(cu.occupation using latin1) as binary) using utf8) 'occupation',
	CONVERT(CAST(CONVERT(sp.shop_address using latin1) as binary) using utf8) 'shop_address',
	p.customer_monthly_income 'customer_income',
	p.customer_monthly_expenditure 'customer_expense',
	p.customer_monthly_profit 'customer_profit',
	CONVERT(CAST(CONVERT(CONCAT(cv.maker ," - ", cv.model) using latin1) as binary) using utf8) 'vehicles',
	CONVERT(CAST(CONVERT(cv.who_is_it using latin1) as binary) using utf8) 'who_is_it',
	CASE crl.estate_types WHEN 1 THEN 'Land' WHEN 2 THEN 'Building' WHEN 3 THEN 'Land and Building' WHEN 4 THEN 'None' ELSE NULL END 'estate_types',
	CONVERT(CAST(CONVERT(crt.relative_name using latin1) as binary) using utf8) 'relative_name',
	CONVERT(CAST(CONVERT(crt.relative_relationship using latin1) as binary) using utf8) 'relationship',
	crt.relative_contact ,
	CONVERT(CAST(CONVERT(CONCAT(g.guarantor_first_name_en , " ",g.guarantor_last_name_en ) using latin1) as binary) using utf8) 'guarantor_full_name_en',
	CONVERT(CAST(CONVERT(CONCAT(g.guarantor_first_name_lo , " ",g.guarantor_last_name_lo ) using latin1) as binary) using utf8) 'guarantor_full_name_lo',
	g.guarantor_contact_no ,
    CASE p.customer_profile WHEN 1 THEN 'New' WHEN 2 THEN 'Current' WHEN 3 THEN 'Dormant' ELSE NULL END 'customer type' ,
    CASE
		p.status WHEN 0 THEN 'Draft'
		WHEN 1 THEN 'Pending Approval from Credit'
		WHEN 2 THEN 'Pending Final Approval from Credit Manager'
		WHEN 3 THEN 'Approved'
		WHEN 4 THEN 'Cancelled'
		ELSE NULL
	END prospect_status,
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
	END 'contract status'
FROM tblprospect p 
LEFT JOIN tblcustomer cu ON (p.customer_id = cu.id)
LEFT JOIN tblcardealershop sp ON (sp.id = p.shop_id)
LEFT JOIN tblcustomervehicles cv ON (cu.id  = cv.customer_id)
LEFT JOIN tblcustomerrelatives crt ON (crt.customer_id = cu.id)
LEFT JOIN tblcustomerrealestate crl ON (crl.prospect_id = p.id)
LEFT JOIN tblguarantor g ON (g.prospect_id = p.id)
LEFT JOIN tblcontract c ON (c.prospect_id = p.id)
WHERE p.id = 87;

SELECT * FROM tblpaymentschedule WHERE contract_id = 1553;

#============ Add days to date sql function (Latho) Update last_payment_date =========== 
SELECT DATE_ADD('1999-12-31 00:00:01', INTERVAL 1 DAY) result; 
#Check the last payment to update 
SELECT p.id, c.ncn , p.loan_amount , p.no_of_payment , p.initial_date, p.first_payment_date , p.last_payment_date ,
	DATE_ADD(p.first_payment_date, INTERVAL p.no_of_payment - 1 DAY) 'new last payment date', c.status 
FROM tblprospect p LEFT JOIN tblcontract c ON (p.id = c.prospect_id)
WHERE c.status in (4,6,7) and p.contract_type = 5 and p.last_payment_date != DATE_ADD(p.first_payment_date, INTERVAL p.no_of_payment - 1 DAY);

#Updated last_payment_date 
UPDATE tblprospect SET last_payment_date = DATE_ADD(first_payment_date, INTERVAL no_of_payment - 1 DAY)
WHERE p.id =  2476;
#Latho request to update last payment date
SELECT p.id,p.case_no , c.ncn , p.loan_amount , p.no_of_payment , p.initial_date, p.first_payment_date , p.last_payment_date ,
	DATE_ADD(p.first_payment_date, INTERVAL p.no_of_payment - 1 DAY) 'new last payment date', c.status 
FROM tblprospect p LEFT JOIN tblcontract c ON (p.id = c.prospect_id)
WHERE case_no in ('805-1','768-1','898-1','940-1','944-1','1032-1','1104-1','982-1','1133-1','1242-1','280-3','315-3','310-3','1308-1');

SELECT p.id,p.case_no , c.ncn , p.loan_amount , p.no_of_payment , p.initial_date, p.first_payment_date , p.last_payment_date ,
	DATE_ADD(p.first_payment_date, INTERVAL p.no_of_payment - 1 DAY) 'new last payment date', c.status 
FROM tblprospect p LEFT JOIN tblcontract c ON (p.id = c.prospect_id)
WHERE p.contract_type = 5 and p.last_payment_date != DATE_ADD(p.first_payment_date, INTERVAL p.no_of_payment - 1 DAY) and p.status = 3;

UPDATE tblprospect SET last_payment_date = DATE_ADD(first_payment_date, INTERVAL no_of_payment - 1 DAY)
WHERE contract_type = 5 and last_payment_date != DATE_ADD(first_payment_date, INTERVAL no_of_payment - 1 DAY) and status = 3;

#=========== Update contract_date contract date ============
-- check 
select c.contract_no , p.initial_date , c.contract_date 
from tblcontract c left join tblprospect p on (p.id = c.prospect_id)
where c.status in (4,6,7) and p.contract_type = 5 and p.initial_date != c.contract_date ;

-- update
update tblcontract c left join tblprospect p on (p.id = c.prospect_id)
set c.contract_date = p.initial_date
where c.contract_no in (2907,2915,2920,2933,2930,2955,2967,2975,2977,2914);


#Covid policy and Lockdown policy #1019 #Check after update on live
SELECT 
	t.prospect_id , t.contract_id , p.initial_date 'date_of_contract',
	p.last_payment_date , '' `no_of_payment`, 
	t.payment_amount , t.interest_amount , t.principal_amount 
FROM tblpaymentschedule t LEFT JOIN tblprospect p ON (p.id = t.prospect_id)
WHERE p.id = 1051;


#Check and udate bank account no and currency 
SELECT *, FROM_UNIXTIME(transfer_datetime, '%Y-%m-%d') FROM tblbankstatement t WHERE account_no <> '010120000617975001' and currency = '';
SELECT b.id, b.currency , b.bank_name , 
	CONVERT (CAST(CONVERT( b.account_no using latin1) as binary) using utf8) 'account_no',
	b.amount , b.reference_no ,
	CONVERT (CAST(CONVERT( b.description using latin1) as binary) using utf8) 'description',
	FROM_UNIXTIME(b.transfer_datetime, '%Y-%m-%d') 'datetime_transfer',
	CONCAT(u.staff_no, " ", u.nickname ) 'created_by',
	FROM_UNIXTIME(b.date_created, '%Y-%m-%d') 'date_created'
FROM tblbankstatement b LEFT JOIN tbluser u ON (u.id = b.created_by_user_id) 
WHERE b.account_no <> '010120000617975001' and b.currency = ''
ORDER BY b.id;

SELECT FROM_UNIXTIME(transfer_datetime, '%Y-%m-%d'), COUNT(id) 
FROM tblbankstatement t WHERE account_no <> '010120000617975001' and currency = ''
GROUP BY FROM_UNIXTIME(transfer_datetime, '%Y-%m-%d') ;

UPDATE tblbankstatement SET currency = 'LAK', account_no = '010120000617975001' 
WHERE account_no <> '010120000617975001' and currency = '';

SELECT * FROM tblpaymentschedule t where prospect_id in (1647,1578,1658) order by prospect_id ;

#Check table currencyrate 
SELECT date_for, usd2lak, usd2thb, lak2usd, lak2thb, thb2usd, thb2lak, FROM_UNIXTIME(date_created,'%Y-%m-%d') 'date_created',
	FROM_UNIXTIME(date_updated,'%Y-%m-%d') 'date_updated'
FROM tblcurrencyrate order by date_for desc;

SELECT * from tblguarantor t where prospect_id = 2432;

SELECT * FROM tblcontract t where prospect_id = 2432;


UPDATE tblcontract SET status = 2 WHERE id = 2478 and status = 4;

SELECT * FROM tblcollection t where id in (93027,92761);
UPDATE tblcollection set actual_payment_amount = payment_amount where id = 93027;


SELECT c.prospect_id, t.* FROM tblcollection t left join tblcontract c on (c.id = t.contract_id) 
where t.actual_payment_amount <> t.payment_amount limit 10;

SELECT COUNT(*) from tblcollection t where t.actual_payment_amount <> t.payment_amount;

#Ticket Stop calculate accrual interest and penlaty with the contract that last payment date < now http://redmine.lalco.la/issues/1207 
SELECT id, initial_date, first_payment_date, last_payment_date, loan_amount , no_of_payment 
FROM tblprospect t 
WHERE last_payment_date BETWEEN '2021-07-01' and  '2021-08-20' and status = 3 and contract_type = 5
limit 30;


SELECT id, first_payment_date, no_of_payment, last_payment_date FROM tblprospect t where id = 2476;

#============ Start JB requested to export user on LMS Money to him ============ 
SELECT email 'email address', CONCAT(first_name," ", last_name) 'name' , staff_no 'staff id'
FROM tbluser t2 ;
#============ END JB requested to export user on LMS Money to him ============ 


SELECT contract_no, date_closed FROM tblcontract t where contract_no = 2048;

SELECT 
	FROM_UNIXTIME(p.date_created, '%Y-%m-%d') Created_date,
	p.id 'contract no',
	c.ncn ,
	p.case_no,
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo, " ", cu.customer_last_name_lo) using latin1) as binary) using utf8) Full_Name_LA,
	cu.Main_Contact_no 'Tel1',
	p.initial_date 'contract date',
	p.loan_amount ,
	p.trading_currency 
FROM tblprospect p
LEFT JOIN tblcustomer cu ON (p.customer_id = cu.id)
LEFT JOIN tblcontract c ON (c.prospect_id = p.id)
limit 20

#============= Contract request to update contract status from Active to Cancelled =============
SELECT * FROM tblcontract t where prospect_id in (314,424,537,473,502);
UPDATE tblcontract set status = 5 where prospect_id in (314,424,537,473,502) and status = 4;

SELECT * FROM tblcollection t WHERE contract_id in (SELECT id FROM tblcontract t where prospect_id in (314,424,537,473,502));

SELECT * FROM tblprospect t where id = 147;
UPDATE tblprospect set trading_currency = 'USD' WHERE id = 147 and trading_currency = 'THB';

SELECT * FROM tblcontract c LEFT JOIN tblprospect p on (p.id = c.prospect_id) WHERE p.id = 642;
UPDATE tblcontract c LEFT JOIN tblprospect p on (p.id = c.prospect_id) set p.initial_date = '2020-12-26', c.contract_date = '2020-12-26' 
WHERE p.id = 642 and p.initial_date = '2020-11-26' and c.contract_date = '2020-11-26' ;

#================= Start Kambe request to export ==============
SELECT 
	col.id 'collection_id',
	c.contract_no ,
	c.ncn ,
	b.id 'bank_statement_id',
	col.date_collected ,
	col.lak_amount + col.bank_lak_amount-col.deduct_lak_amount as "LAK",
	col.thb_amount + col.bank_thb_amount-col.deduct_thb_amount as "THB",
	col.usd_amount + col.bank_usd_amount-col.deduct_usd_amount as "USD",
	b.bank_name ,
	b.account_no ,
	CASE 
		WHEN b.description LIKE 'BPAY|LALCO|%' THEN 'BPAY App'
		WHEN b.description LIKE 'TRANSFER|FT|%' THEN 'BCEL One General'
		WHEN b.description LIKE '%Deposit%' THEN 'Cash Deposit'
		WHEN b.description LIKE 'TRF%' THEN 'Transfer from bank'
		WHEN b.description LIKE '%I-BANK%' THEN 'Transfer by I-Bank'
		WHEN b.description LIKE '%BCOME%' THEN 'Transfer by BCOME'
		WHEN b.description LIKE '%ATM%' THEN 'Transfer from ATM'
		WHEN b.description LIKE '%ONEPAY%' THEN 'ONEPAY'
		ELSE 'Unknown'
	END 'Kind of transfer',
	FROM_UNIXTIME(b.transfer_datetime, '%Y-%m-%d %H:%m:%s') "Transfer date",
	CONVERT(CAST(CONVERT(CONCAT(b.description ) using latin1) as binary) using utf8) Description 
FROM tblbankstatement b 
LEFT JOIN tblcollection col on (b.id = col.banktransfer_id)
LEFT JOIN tblcontract c on (c.id = col.contract_id)
ORDER BY b.transfer_datetime desc;
#================= END Kambe request to export ==============

#======= [daily_report] ====== START Yoshi request to check the payment of each customer every day =========> https://docs.google.com/spreadsheets/d/1l6CSoDHrF7xs_5WRSKN1t2k3nfRreYLVLdHAKyNek30/edit#gid=450723317
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

-- check collection and who is approved
SELECT c.contract_no , c.ncn ,
	co.id 'collection_id', FROM_UNIXTIME(co.date_created, '%Y-%m-%d') 'date_creatd', co.date_collected , co.payment_amount , 
	FROM_UNIXTIME(co.approve_datetime, '%Y-%m-%d') 'date_approved', ua.staff_no , ua.nickname ,
	CASE co.status WHEN -1 THEN 'Draft' WHEN 0 THEN 'Pending'
		WHEN 1 THEN 'Approved' WHEN 2 THEN 'Rejected' ELSE ''
	END 'collection_status',
	CASE
		co.collection_method WHEN 1 THEN 'Cash Office'
		WHEN 2 THEN 'Transfer'
		WHEN 3 THEN 'Sold Bike'
		WHEN 4 THEN 'Litigation Recovery'
		WHEN 5 THEN 'Early/Late Closure'
		ELSE NULL
	END 'collection_method'
from tblcontract c
left join tblcollection co on (co.contract_id = c.id)
left join tbluser ua on (ua.id = co.approve_by_staff_id)
where co.status != 1 and co.payment_amount != 0 and co.date_collected >= '2022-02-01'
order by co.date_collected desc;

select date(now()) ;
SELECT  DATE_ADD(date(now()), INTERVAL -5 DAY), DATE_ADD(p.first_payment_date, INTERVAL + 1- 1 DAY)  from tblprospect p;
#=========== END Yoshi request to check the payment of each customer every day =========

#======= [daily_report] ======== START Check collection payment for Sack 43 Collection AAA collection payment ===========> https://docs.google.com/spreadsheets/d/1l6CSoDHrF7xs_5WRSKN1t2k3nfRreYLVLdHAKyNek30/edit#gid=2017818699
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

SELECT * from tblcollection t where id = 107111;
SELECT * from tblpayment t WHERE contract_id = 2774;

select datediff(date(now()), '2022-01-18') - 1;
select datediff(date(now()), "2021-11-13"); -- return days;
select timestampdiff(day,'2022-02-05','2022-03-06'); -- return days; 
select timestampdiff(month,'2009-06-18','2009-07-29') ; -- return months; 
select timestampdiff(year,'2006-06-18','2009-07-29'); -- return years; 

select date_add(date(now()), interval - 2 day); -- return the date before now 10 days
select date_add(date(now()), interval + 2 month) ; --  return the date before now 2 months
select date_add(date(now()), interval + 2 year); --  return the date before now 2 years

select str_to_date(concat(year(now()), '-', month(now()), '-05'), '%Y-%m-%d') as target_date; -- date the date with fixed day as 05

select date_add(date_add(date(now()), interval - 2 month), interval - 1 day)

SELECT WEEKDAY("2022-07-26"); -- 0=Monday, 1=Tuesday, 2=Wednesday, 3=Thursday, 4=Friday, 5=Saturday, 6=Sunday
select ps.prospect_id, datediff(date(now()), '2022-07-25') 'weekday' , weekday(ps.payment_date) 'weekend'
from tblpaymentschedule ps where ps.prospect_id in (3168) group by ps.prospect_id ;


select '2024-07-25', date_sub('2024-07-25', interval (dayofweek('2024-07-25') + 5) % 7 day) as monday_date; -- get date for Monday from each day


SELECT week("2021-11-22")
#============ END Check collection payment for Sack 43 Collection sheet daily_report ===========

select date_add(date_add(date(now()), interval - 1 month), interval - 1 day);
select date_add(date(now()), interval + 1 month); -- edate in sql

#======= [%_of_paid] ======== Calculate the paid amount Sheet %_of_paid  ================> https://docs.google.com/spreadsheets/d/1l6CSoDHrF7xs_5WRSKN1t2k3nfRreYLVLdHAKyNek30/edit#gid=88806333
select c.contract_no , p.last_payment_date , 
	CASE c.status WHEN 0 THEN 'Pending' WHEN 1 THEN 'Pending Approval' WHEN 2 THEN 'Pending Disbursement'
		WHEN 3 THEN 'Disbursement Approval' WHEN 4 THEN 'Active' WHEN 5 THEN 'Cancelled' WHEN 6 THEN 'Refinance' WHEN 7 THEN 'Closed' ELSE NULL
	END contract_status,
	sum(case when co.status = 1 and co.date_collected >= date_add(date_add(date(now()), interval - 1 month), interval - 1 day)
		then co.usd_amount + co.bank_usd_amount end) 'usd_amount',
	sum(case when co.status = 1 and co.date_collected >= date_add(date_add(date(now()), interval - 1 month), interval - 1 day)
		then co.thb_amount + co.bank_thb_amount end) 'thb_amount',
	sum(case when co.status = 1 and co.date_collected >= date_add(date_add(date(now()), interval - 1 month), interval - 1 day) 
		then co.lak_amount + co.bank_lak_amount end) 'lak_amount',
	sum(case when co.status = 1 and co.date_collected >= date_add(date_add(date(now()), interval - 1 month), interval - 1 day) 
		then co.payment_amount end) 'paid_amount',
	sum(co.payment_amount ) 'all_paid_amount'
from tblcontract c
left join tblprospect p on (p.id = c.prospect_id)
left join tblcollection co on (co.contract_id = c.id) 
where p.contract_type = 5 and c.status in (4,6,7)
group by contract_no;

select date_add(date(now()), interval - 14 day);
#======= [%_of_paid] ======== Calculate the paid amount Sheet %_of_paid in 14days  ================
select c.contract_no , p.last_payment_date , 
	CASE c.status WHEN 0 THEN 'Pending' WHEN 1 THEN 'Pending Approval' WHEN 2 THEN 'Pending Disbursement'
		WHEN 3 THEN 'Disbursement Approval' WHEN 4 THEN 'Active' WHEN 5 THEN 'Cancelled' WHEN 6 THEN 'Refinance' WHEN 7 THEN 'Closed' ELSE NULL
	END contract_status,
	sum(case when co.status = 1 and co.date_collected >= date_add(date(now()), interval - 14 day)
		then co.usd_amount + co.bank_usd_amount end) 'usd_amount',
	sum(case when co.status = 1 and co.date_collected >= date_add(date(now()), interval - 14 day)
		then co.thb_amount + co.bank_thb_amount end) 'thb_amount',
	sum(case when co.status = 1 and co.date_collected >= date_add(date(now()), interval - 14 day)
		then co.lak_amount + co.bank_lak_amount end) 'lak_amount',
	sum(case when co.status = 1 and co.date_collected >= date_add(date(now()), interval - 14 day)
		then co.payment_amount end) 'paid_amount',
	sum(case when co.status = 1 then co.payment_amount end) 'all_paid_amount'
from tblcontract c
left join tblprospect p on (p.id = c.prospect_id)
left join tblcollection co on (co.contract_id = c.id) 
where p.contract_type = 5 and c.status in (4,6,7)
group by contract_no;

#======= [Yoshi] ======== Calculate the paid amount and outstanding amount Sheet Yoshi ================> https://docs.google.com/spreadsheets/d/1l6CSoDHrF7xs_5WRSKN1t2k3nfRreYLVLdHAKyNek30/edit#gid=742364173
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

#======= [daily_monitor] ======== AAA data to sheet daily_monitor ================> https://docs.google.com/spreadsheets/d/1l6CSoDHrF7xs_5WRSKN1t2k3nfRreYLVLdHAKyNek30/edit#gid=914214082
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

#======= [customer_info] ======== START Export customer and guarantor information to Yoshi and Paolor =============> https://docs.google.com/spreadsheets/d/1l6CSoDHrF7xs_5WRSKN1t2k3nfRreYLVLdHAKyNek30/edit#gid=1506076242
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

#======= [contract_source] ======== Contract source on google sheet AAA Collection Report ================> https://docs.google.com/spreadsheets/d/1l6CSoDHrF7xs_5WRSKN1t2k3nfRreYLVLdHAKyNek30/edit#gid=1341146732
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


select c.contract_no , c.ncn , pm.*
from tblcontract c 
left join tblprospect p on (p.id = c.prospect_id)
left join tblpayment pm on (c.id = pm.contract_id)
where c.status in (4,6,7) and p.contract_type = 5 -- and p.id in (3168)

-- Export to sheet name collection
select co.id, c.prospect_id , co.contract_id , co.date_collected ,
	co.usd_amount + co.bank_usd_amount 'usd_amount',
	co.thb_amount + co.bank_thb_amount 'thb_amount',
	co.lak_amount + co.bank_lak_amount 'lak_amount',
	co.payment_amount ,
	co.status 
from tblcollection co left join tblcontract c on (c.id = co.contract_id) left join tblprospect p on (p.id = c.prospect_id)
where c.status in (4,6,7) and p.contract_type = 5;

#Update datetime transfer in table bank statement and collection with one case
-- select to check
SELECT b.id, b.reference_no, FROM_UNIXTIME(b.transfer_datetime,'%Y-%m-%d %H:%m:%s') 'now_transfer_datetime', RIGHT(b.description,19) 'correct_transfer_datetime', 
    b.transfer_datetime ,    UNIX_TIMESTAMP('2021-10-10 20:38:02'), co.transfer_date , co.date_collected 
FROM tblbankstatement b left join tblcollection co on (b.id = co.banktransfer_id)
WHERE b.id = 6261;

#============ Calculate to amount to closed and refinance =============
select * from tblpayment t where contract_id = 2856;

SELECT COUNT(*) from tblpayment t ;

#Users data check for disable 
select id, staff_no, nickname , concat( first_name ," - ",last_name ) 'full name', email, department, `role` ,
	CASE status WHEN 0 THEN 'Inactive' WHEN 1 THEN 'Active' ELSE NULL END 'status',
	FROM_UNIXTIME(last_login_datetime, '%Y-%m-%d %H:%m:%s') 'Last Login'
from tbluser 
-- where id in (11249,11092)
-- where `role` = 'admin' and status = 1
order by id desc, staff_no ;

#Disable users
update tbluser set status = 0
 where id in (11249,11092)
and status = 1;



#========= Start check and update collection schedule for lockdown policy =============
SELECT c.contract_no ,	c.ncn ,
	c.contract_date , p.initial_date , c.contract_date = p.initial_date 'check1',
	p.first_payment_date, DATE_ADD(p.initial_date , INTERVAL 1 DAY) 'real_1ns_payment_date', p.first_payment_date = DATE_ADD(p.initial_date , INTERVAL 1 DAY) 'check2',
	p.no_of_payment , count(ps.prospect_id) , p.no_of_payment = count(ps.prospect_id) 'check3',
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
	END 'contract status'
FROM tblcontract c 
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
LEFT JOIN tblpaymentschedule ps ON (p.id = ps.prospect_id)
WHERE c.status in (4,6,7) and p.contract_type = 5 and p.initial_date != c.contract_date 
GROUP BY p.id
ORDER BY c.prospect_id ;


SELECT c.contract_no , c.id,
	/*p.initial_date , c.contract_date , p.initial_date = c.contract_date 'check_contract_date',*/
	p.first_payment_date ,  DATE_ADD(p.initial_date , INTERVAL 1 DAY) 'real_1ns_payment_date', A.payment_date, pm.due_date ,
	p.first_payment_date = A.payment_date 'check_1st_payent_date',
	p.first_payment_date - A.payment_date 'update_key'
FROM tblcontract c
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
LEFT JOIN tblpaymentschedule A ON A.id = (select id from tblpaymentschedule where contract_id=c.id order by payment_date limit 1)
LEFT JOIN tblpayment pm ON pm.id = (select id from tblpayment where contract_id=c.id order by due_date limit 1)
WHERE c.status in (4,6,7) and p.contract_type = 5 
	and p.first_payment_date != pm.due_date

SELECT id 'prospect_id', no_of_payment , initial_date , WEEKDAY(initial_date) , first_payment_date , WEEKDAY(first_payment_date) , last_payment_date , WEEKDAY(last_payment_date) 
from tblprospect t 
where contract_type = 5 and WEEKDAY(first_payment_date) in (5,6) and no_of_payment = 105

select ps.prospect_id , ps.contract_id, ps.payment_date , pm.due_date , 
DATE_ADD(ps.payment_date , INTERVAL - 1 DAY) 'new_payment_date', DATE_ADD(pm.due_date , INTERVAL - 1 DAY) 'new_due_date'
from tblpaymentschedule ps left join tblpayment pm on (ps.id = pm.schedule_id)
where ps.prospect_id in (1117,1052,1199,1300,1203,1271) --  ps.payment_date =  ps.payment_date - 1, pm.due_date = pm.due_date - 1

select ps.prospect_id , ps.contract_id, ps.payment_date , pm.due_date, 
DATE_ADD(ps.payment_date , INTERVAL - 2 DAY) 'new_payment_date', DATE_ADD(pm.due_date , INTERVAL - 2 DAY) 'new_due_date'
from tblpaymentschedule ps left join tblpayment pm on (ps.id = pm.schedule_id)
where ps.prospect_id in (1296) --  ps.payment_date =  ps.payment_date - 2, pm.due_date = pm.due_date - 2

select ps.prospect_id , ps.contract_id, ps.payment_date , pm.due_date , 
DATE_ADD(ps.payment_date , INTERVAL + 1 DAY) 'new_payment_date', DATE_ADD(pm.due_date , INTERVAL + 1 DAY) 'new_due_date'
from tblpaymentschedule ps left join tblpayment pm on (ps.id = pm.schedule_id)
where ps.prospect_id in (1792) --  ps.payment_date =  ps.payment_date + 1, pm.due_date = pm.due_date + 1

update tblpaymentschedule ps left join tblpayment pm on (ps.id = pm.schedule_id)
set ps.payment_date = DATE_ADD(ps.payment_date , INTERVAL - 1 DAY) , pm.due_date = DATE_ADD(pm.due_date , INTERVAL - 1 DAY)
where ps.prospect_id in (1117,1052,1199,1300,1203,1271)

update tblpaymentschedule ps left join tblpayment pm on (ps.id = pm.schedule_id)
set ps.payment_date = DATE_ADD(ps.payment_date , INTERVAL - 2 DAY) , pm.due_date = DATE_ADD(pm.due_date , INTERVAL - 2 DAY)
where ps.prospect_id in (1296)

update tblpaymentschedule ps left join tblpayment pm on (ps.id = pm.schedule_id)
set ps.payment_date = DATE_ADD(ps.payment_date , INTERVAL + 1 DAY) , pm.due_date = DATE_ADD(pm.due_date , INTERVAL + 1 DAY)
where ps.prospect_id in (1792)
#=========  End check and update collection schedule for lockdown policy =============

#============== Update penalty ================
select * from tblpayment t where contract_id = 93 order by due_date , FIELD(`type`, 'penalty','interest','principal') 

UPDATE tblpayment set amount = 10, paid_amount = 10 where contract_id = 60 and due_date = '2020-12-05' and `type` = 'penalty';
UPDATE tblpayment set amount = 18, paid_amount = 18 where contract_id = 60 and due_date = '2021-01-05' and `type` = 'penalty';
UPDATE tblpayment set amount = 31, paid_amount = 31 where contract_id = 60 and due_date = '2021-08-05' and `type` = 'penalty';

DELETE from tblpayment where  contract_id = 60 and due_date = '2021-11-05' and `type` = 'penalty' ;

UPDATE tblpayment set amount = 6 where contract_id = 60 and due_date = '2021-11-15' and `type` = 'accrual' ;

SELECT * FROM tblpayment WHERE contract_id = 81915 and `type` = 'penalty' order by due_date ;
 -- Update penalty 
UPDATE tblpayment SET amount = 51 WHERE contract_id = 81915 and `type` = 'penalty' and due_date <= '2021-03-05';
 -- DELETE penalty
DELETE FROM tblpayment WHERE contract_id = 81915 and `type` = 'penalty' ;

#=============== Ringi to closed and void remaining amount for VIeng 1042 ============
-- check 
select * from tblpayment t where contract_id = 93 order by due_date , FIELD(`type`, 'penalty','interest','principal') ;
SELECT c.contract_no , c.id 'contract_id',
	SUM(CASE WHEN t.`type` = 'principal' THEN t.amount - t.paid_amount END) 'principal_out_standing',
	SUM(CASE WHEN t.`type` = 'interest' THEN t.amount - t.paid_amount END) 'interest_out_standing',
	SUM(CASE WHEN t.`type` = 'penalty' THEN t.amount - t.paid_amount END) 'penalty_out_standing',
	SUM(CASE WHEN t.`type` = 'principal' THEN t.amount - t.paid_amount - t.void_amount END) 'principal_to_closed',
	SUM(CASE WHEN t.`type` = 'interest' THEN t.amount - t.paid_amount - t.void_amount END) 'interest_to_closed'
FROM tblpayment t LEFT JOIN tblcontract c ON (t.contract_id = c.id )
WHERE c.contract_no in (52,99)
GROUP BY c.contract_no ;

-- UPDATE and DELETE 
delete from tblpayment where contract_id = 45 and `type` = 'penalty' and due_date >= '2021-04-05';
delete from tblpayment where contract_id = 93 and `type` = 'penalty' and due_date >= '2021-07-05';


#=========== Leemee 2383 requests 2022-03-14 to export AR of AAA as at 28-Feb-22 ============
select 
	c.contract_no 'System ID', 
	c.contract_date 'Date',
	p.loan_amount 'Loan Amount', 
	null 'Principal payable',
	dr.interest_payable 'Interest ',
	dr.total_principal_collected 'Principal collected',
	dr.total_interest_collected 'Interest collected',
	dr.total_principal_outstanding 'Outstanding Principal',
	dr.total_interest_outstanding 'Outstanding Interest',
	dr.days_due 'Days Late',
	null 'Rank',
	CASE c.status WHEN 0 THEN 'Pending'
        WHEN 1 THEN 'Pending Approval'
        WHEN 2 THEN 'Pending Disbursement'
        WHEN 3 THEN 'Disbursement Approval'
        WHEN 4 THEN 'Active'
        WHEN 5 THEN 'Cancelled'
        WHEN 6 THEN 'Refinance'
        WHEN 7 THEN 'Closed'
        ELSE NULL
    END 'Status'
from tblcontract c 
left join tblprospect p on (p.id = c.prospect_id)
left join tbldailyreport dr on (c.id = dr.contract_id)
where dr.date = '2022-07-31';

-- ________________________________ AAA & Cash lao impairment ________________________________ --
select dr.`date` 'Date report', 
	case p.contract_type when 1 then 'Moneymax' when 2 then 'Moneymax' when 3 then 'Moneymax' when 4 then 'Moneymax'
		when 5 then 'AAA' when 6 then 'Cash Lao' when 7 then 'Cash Lao' when 8 then 'Cash Lao' else null
	end 'company',
	case p.contract_type when 1 then 'SME Car' when 2 then 'SME Bike' when 3 then 'Car Leasing' when 4 then 'Bike Leasing'
		when 5 then 'Micro Leasing' when 6 then 'Cash Lao' when 7 then 'Quick Loan' when 8 then 'Money Lao' else null
	end 'contract type',
	c.contract_no 'System ID', c.ncn, c.contract_date ,
	p.trading_currency 'currency', p.loan_amount 'Loan Amount', 
	dr.interest_payable 'Interest ',
	dr.total_principal_collected 'Principal collected',
	dr.total_interest_collected 'Interest collected',
	dr.total_principal_outstanding 'Outstanding Principal',
	dr.total_interest_outstanding 'Outstanding Interest',
	dr.days_due 'Days Late',
	CASE dr.contract_status WHEN 0 THEN 'Pending' WHEN 1 THEN 'Pending Approval' WHEN 2 THEN 'Pending Disbursement' WHEN 3 THEN 'Disbursement Approval'
        WHEN 4 THEN 'Active' WHEN 5 THEN 'Cancelled' WHEN 6 THEN 'Refinance' WHEN 7 THEN 'Closed' ELSE NULL
    END 'Status',
    case when dr.contract_status in (6,7) then 'S' when dr.days_due =0 then 'S' when dr.days_due <=5 then 'A' when dr.days_due <=10 then 'B'
    	when dr.days_due <=20 then 'C' when dr.days_due <=30 then 'F' when dr.days_due >30 then 'FF' else null
	end 'Rank based on Delay Date',
	case when dr.contract_status in (6,7) then '0%' when dr.days_due =0 then '0%' when dr.days_due <=5 then '3%' when dr.days_due <=10 then '10%'
    	when dr.days_due <=20 then '50%' when dr.days_due <=30 then '80%' when dr.days_due >30 then '100%' else null
	end '% of Impairmanets',
	dr.total_principal_outstanding * (case when dr.contract_status in (6,7) then 0 when dr.days_due =0 then 0 when dr.days_due <=5 then 0.03 when dr.days_due <=10 then 0.1
    	when dr.days_due <=20 then 0.5 when dr.days_due <=30 then 0.8 when dr.days_due >30 then 1 else null
	end) 'Amount of Impairments in Original amount',
	null 'Exchange Rate',
	null 'Amount of Impairments in USD'
from tblcontract c 
left join tblprospect p on (p.id = c.prospect_id)
left join tbldailyreport dr on (c.id = dr.contract_id)
where c.status in (4,6,7) and p.contract_type in (5,6,7,8) and dr.date in ('2024-01-31')
order by dr.`date` , p.contract_type ;




-- Gini machine
select cu.customer_first_name_en , cu.customer_last_name_en , cu.main_contact_no , 
	case when timestampdiff(year, cu.date_of_birth, date(now())) between 0 and 200 then timestampdiff(year, cu.date_of_birth, date(now())) else null end `customer_age`,
	cu.address_province `customer_address_province`, cu.business_type `customer_business_type`, 
	convert(cast(convert(cu.occupation using latin1) as binary) using utf8) `customer_occupation`,
	case when 2023 - cu.work_year <0 or 2023 - cu.work_year >200 then null else 2023 - cu.work_year end `customer_work_year`, 
	null `is_blacklist`, p.customer_monthly_income , p.customer_monthly_expenditure , p.customer_monthly_profit ,
	g.guarantor_first_name_en , g.guarantor_last_name_en , g.guarantor_contact_no, 
	case when timestampdiff(year, g.guarantor_dob, date(now())) between 0 and 200 then timestampdiff(year, g.guarantor_dob, date(now())) else null end `customer_age`,
	g.address_province `guarantor_address_province` , convert(cast(convert(g.guarantor_occupation using latin1) as binary) using utf8) `guarantor_occupation`,
	case when 2023 - g.guarantor_work_year between 0 and 200 then 2023 - g.guarantor_work_year else null end `guarantor_work_year`, 
	g.guarantor_monthly_income , g.guarantor_monthly_expenditure , g.guarantor_monthly_profit ,
	p.loan_amount, p.no_of_payment , p.fee , p.payment_schedule_type , p.monthly_interest , p.broker_commission, case when p.status = 3 then 1 else 0 end `OK`
from tblcustomer cu left join tblprospect p on (p.customer_id=cu.id)
left join tblguarantor g on (g.prospect_id=p.id)
where p.status in (0,3) and p.notes is not null
	 and p.contract_type in (5) limit 1000 -- AAA
	-- and p.contract_type in (6,7,8) -- Cash lao





-- last collection date
select c.contract_no , c.id, co.id 'collection_id', co.date_collected , co.payment_amount , c.status 
from tblcontract c left join tblprospect p on (p.id = c.prospect_id)
left join tblcollection co on co.id = (select id from tblcollection where contract_id = c.id and status = 1 order by date_collected desc limit 1)
where c.status in (4,6,7) and p.contract_type in (5, 6,7,8);






























