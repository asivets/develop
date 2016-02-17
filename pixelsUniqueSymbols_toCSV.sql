drop table if exists temp_symbols; 

create table temp_symbols
(
	id int unsigned not null auto_increment primary key,
	name_sym varchar(1) default null,
	code_sym varchar(1) default null
)

drop procedure if exists temp_load_symbols;

delimiter #
create procedure temp_load_symbols()

begin 

declare v_counter INT default 1;

	while v_counter < 225 do
		insert into temp_symbols (name_sym)
		select distinct substring(name, v_counter, 1)
		from pixels;

		insert into temp_symbols (code_sym)
		select distinct substring(code, v_counter, 1)
		from pixels

		set v_counter = v_counter + 1;
	end while;

	commit;

end #;

call load_name_code_symbols();

select distinct name_sym, code_sym 
from temp_symbols
order by name_sym desc, code_sym desc
INTO OUTFILE '/tmp/pixel_name_code_symbols.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
