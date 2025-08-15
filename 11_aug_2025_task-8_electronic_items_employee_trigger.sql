create table electronic_items(
id serial primary key,
item_name varchar,
price decimal(10,2),
stock_quantity int,
warranty_period int,
brand_name varchar
);

select * from electronic_items;

create or replace function check_price_stock()
returns trigger as $$
begin
    	if new.price <= 10000 then
    	raise exception'price cannot be less than 10000';
		
    	elseif new.stock_quantity <= 5 then
        raise exception 'restock required';
		
    	end if;

    	return new;
end;
$$ language plpgsql;

create trigger trigger_price_stock
before update or insert on electronic_items
for each row
execute function check_price_stock();


create or replace function check_brand_warranty()
returns trigger as $$
begin
		if new.brand_name not in ('apple','samsung','sony') then
		raise exception 'invalid brand';

		elseif new.warranty_period >=24 then
		raise exception 'warranty period must be less than 24 months';

		end if;

		return new;

end;
$$ language plpgsql;

create trigger trigger_brand_warranty
before insert or update on electronic_items
for each row
execute function check_brand_warranty

select * from electronic_items;

-------------------------------------------------------------------------------------------------------------------

create table orders (
order_id SERIAL primary key,
customer_name varchar(100),
order_date DATE default current_date,
amount numeric(10,2),
status varchar(20)
);

select * from orders;

create or replace function set_default_status()
returns trigger as  $$
begin

    if new.status is null or new.status = '' then
        new.status := 'Processing';
    end if;

    return new;
	
end;
$$ language plpgsql;

create trigger trigger_set_default_status
before insert on  orders
for each row
execute function set_default_status();


insert into  orders (customer_name, amount) VALUES ('Aditya rait', 2500);

alter table orders add column discount numeric(5,2);

select * from orders;

create or replace function apply_discount()
returns trigger as $$
begin
    
    if new.amount >=5000 then
        new.discount := 15.00;  
    else
        new.discount := 2.00;   
    end if;

    return new;
	
end;
$$ language plpgsql;

create trigger trigger_apply_discount
before insert or update on orders
for each row
execute function apply_discount();


insert into orders (customer_name, amount, status) values ('Ankita Verma', 12000, 'Shipped');

insert into orders (customer_name, amount) values ('Aniket Waghmare', 1200);

select * from orders;