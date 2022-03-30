options nocenter nonumber nodate errors=0 ps=76 ls=64 compress=no;
run;

*libnames;
libname risk v9  "Z:\MIS436\team_data";


proc import file="Z:\MIS436\team_data\DataCoSupplyChainDataset.csv"
    out=work.ldel

    dbms=csv replace;
	getnames=YES;
run;

proc contents data=ldel;
run;

data risk.ldel1; set ldel;
only_o=datepart(order_date__DateOrders_);
order_m=month(only_o);
order_d=day(only_o);
order_yr=year(only_o);
only_d=datepart(shipping_date__DateOrders_);
ship_m=month(only_d);
ship_d=day(only_d);
ship_yr=year(only_d);
if ship_d<10 then ship_d3=1;else
if ship_d<20 then ship_d3=2;else
ship_d3=3;

if order_d<10 then order_d3=1;else
if order_d<20 then order_d3=2;else
order_d3=3;



days_til_ship=floor((shipping_date__DateOrders_ - order_date__DateOrders_)/86400);


if customer_state in (		'CT'	'ME'	'NH'	'RI'	'VT'				) then region=	1	;else
if customer_state in (		'NJ'	'NY'	'PR'						) then region=	2	;else
if customer_state in (		'DE'	'DC'	'MD'	'PA'	'VA'	'WV'			) then region=	3	;else
if customer_state in (		'AL'	'FL'	'GA'	'KY'	'MS'	'NC'	'SC'	'TN'	) then region=	4	;else
if customer_state in (		'IL'	'IN'	'MI'	'MN'	'OH'	'WI'			) then region=	5	;else
if customer_state in (		'AR'	'LA'	'NM'	'OK'	'TX'				) then region=	6	;else
if customer_state in (		'IA'	'KS'	'MO'	'NE'					) then region=	7	;else
if customer_state in (		'CO'	'MT'	'ND'	'SD'	'UT'	'WY'			) then region=	8	;else
if customer_state in (		'AZ'	'CA'	'HI'	'NV'					) then region=	9	;else
if customer_state in (		'AK'	'IA'	'OR'	'WA'					) then region=	10	;
else region=	11	;

if order_status in ('COMPLETE' 'ON_HOLD' 'PROCESSING');

keep Benefit_per_order
Department_Name
Late_delivery_risk
Order_Item_Discount
Order_Item_Discount_Rate
Order_Item_Product_Price
Order_Item_Profit_Ratio
Order_Item_Quantity
Order_Item_Total
Order_Profit_Per_Order
Product_Price
Sales
Sales_per_customer
Shipping_Mode
days_til_ship
order_d3
order_d
order_m
order_yr
region
ship_d3
ship_d
ship_m
ship_yr
;

run;

proc freq data=risk.ldel1;
table Late_delivery_risk*days_til_ship;
run;
