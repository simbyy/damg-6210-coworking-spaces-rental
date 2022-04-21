exec create_all_tables();

exec create_all_tables();

exec create_all_tables();

select * from customer;

exec create_all_tables();

select * from rental_feedback;

drop table rental_feedback;

exec create_all_tables();

select * from rental_complaint;

delete from rental_complaint where complaint_severity = 'LOW';

delete from rental_complaint where complaint_status = 'RESOLVED';

select * from rental_complaint;

update rental_complaint set complaint_description = 'WIFI WAS NOT WORKING PROPERLY' where complaint_id = 1;

update rental_complaint set complaint_description = 'BACKGROUND MUSIC IS VERY HIGH IN VOLUME' where complaint_id = 7;

select * from rental_complaint;

exec create_all_tables();

select * from customer;

update customer set c_state='Massachusetts' where c_city='Boston';

select * from customer;

insert into customer values (21, 'Jason', 'Bateman', 'batman_j@outlook.com', 9899929889, 'jbate', 'sAfePaSs', 'Los Angeles', 'California', 90210, (select current_date from dual));

select * from customer;

exec create_all_tables();

exec create_all_tables();

exec create_all_tables();

exec create_all_tables();

exec create_all_tables();
