set serveroutput on;

exec create_all_tables();
select * from customer;
select * from customer_card_details;
select * from owner;
select * from rental_booking_backlog;
select * from rental_complaint;
select * from rental_posting;

exec sign_up_customer('netra', 'awate', 'netra.a@gmail.com', 6178777654, 'netra_a', 'AAABBBC', 'Boston', 'Massachusetts', '02115');
exec sign_up_owner('simran', 'bhatia', 's@bhatia.com', 6177778900, 'simran', 'SMMNHS', 'Boston', 'Massachusetts', '02129');
exec DELETE_CUSTOMER_CARD_DETAILS(2);
exec DELETE_RENTAL_BOOKING_BACKLOG(3);
exec DELETE_RENTAL_COMPLAINT(4);
exec DELETE_RENTAL_FEEDBACK (5);
exec DELETE_RENTAL_POSTING(6);
exec UPDATE_RENTAL_COMPLAINT_STATUS(3, 'Resolved');
exec WRITE_RENTAL_BOOKING_BACKLOG (7,2,sysdate,sysdate);