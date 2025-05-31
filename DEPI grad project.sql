select * 
from [Order fact table]

select * 
from [Customer DIM]

select * 
from [product DIM]

select * 
from [DIm shipping]

-----------Total sales--------

select SUM(Sales) as total_sales
from [Order fact table]

------higest prince in each cat----

select Category_Name , MAX(Product_Price) as higest_price_product
from [product DIM]
group by Category_Name   

------------non profit orders by the same customer--------

select Order_Id ,sum(Benefit_per_order) as non_profit_order
from [Order fact table]
where Benefit_per_order <0
group by Order_Id 
 
 -----total loss----

select sum(Benefit_per_order) as 'Total loss from orders'
from [Order fact table]
where Benefit_per_order <0

-----recipt---------

select p.Product_Name,p.product_id,p.Product_Price,c.Custom_Name as customer_name , c.customer_city,o.order_id,o.order_date_DateOrders
from [product DIM] p
join [Order fact table] o on p.product_id = o.product_id
join [Customer DIM] c on c.Customer_Id= o.Order_Customer_Id
join [DIm shipping] s on o.Order_Id=s.order_id

-----max profitable country---

select c.Customer_Country , max (o.sales) as 'max sales per country'
from [Customer DIM] c
join [Order fact table] o
on c.Customer_Id = o.Order_Customer_Id
group by c.Customer_Country

----Modofiy value in the customer table--------

update [Customer DIM]
set Customer_Country='USA'
where Customer_Country='EE. UU.'

--------------edit in data base--------------------------------------------------------------------------------------
ALTER TABLE [dbo].[Order fact table]
ALTER COLUMN order_date_DateOrders DATE

select distinct Order_Id
from [dbo].[Order fact table]
where Order_Id NOT IN (select Order_Id from [dbo].[DIm shipping])
-------------------------------------------------------------------------------------------------------------------

-----product that no one ordered----

select p.product_id,p.Product_Name,p.Category_Name,o.order_id
from [product DIM] p
left join [Order fact table] o
on o.product_id=p.product_id
where o.Order_Id is null

------ profit/loss per segment------
 
select o.Order_Id,sum (o.Order_Profit_Per_Order) as 'Income per Segment',c.Customer_Segment,c.Customer_City
from [Order fact table] o
join [Customer DIM] c
on o.Order_Customer_Id=c.Customer_Id
group by c.Customer_Segment,c.Customer_City,o.Order_Id

----------total sales by customer country----

select c.Customer_Country, p.Product_Name, SUM(o.Sales) as Total_Sales 
from [Order fact table] o
join [Customer DIM] c on Order_Customer_Id = c.Customer_ID
join [product DIM] p on o.Product_ID = p.Product_ID
group by c.Customer_Country, p.Product_Name
order by c.Customer_Country, Total_Sales DESC


-----------processing time--------------

select DATEDIFF(DAY, o.order_date_DateOrders,s.adj_shipping_date_order) as 'Processing time'
from [Order fact table] o
join [DIm shipping] s
on o.Order_Id =s.order_id
where DATEDIFF(DAY, o.order_date_DateOrders,s.adj_shipping_date_order) between 1 and 100
