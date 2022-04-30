-- User 1 -------------------------------------------------------------------------------------------------------------
call remove_objects('anonymous_user','USER');
create user anonymous_user identified by "netraAwate0987";
grant create session to anonymous_user;
grant execute on sign_up_customer to anonymous_user;
grant execute on sign_up_owner to anonymous_user;

-- User 2 --------------------------------------------------------------------------------------------------
call remove_objects('customer_user','USER');
create user customer_user identified by "netraAwate0987";
grant create session to customer_user;
grant execute on update_customer_details to customer_user;
grant select on read_rental_posting_table to customer_user;
grant select on read_rental_booking_backlog to customer_user;
grant select on READ_RENTAL_COMPLAINT to customer_user;
grant select on READ_RENTAL_FEEDBACK to customer_user;
grant execute on WRITE_RENTAL_BOOKING_BACKLOG to customer_user;
grant execute on delete_rental_booking_backlog to customer_user;
grant execute on write_credit_card_details to customer_user;
grant execute on delete_customer_card_details to customer_user;
grant select on VIEW_RENTAL_COMPLAINT to customer_user;
grant execute on WRITE_RENTAL_COMPLAINT to customer_user;
grant execute on DELETE_RENTAL_COMPLAINT to customer_user;
grant select on VIEW_RENTAL_FEEDBACK to customer_user;
grant execute on WRITE_RENTAL_FEEDBACK to customer_user;
grant execute on delete_rental_feedback to customer_user;
grant select on CUSTOMER_CARD_V to customer_user;

-- User 3 -------------------------------------------------------------------------------------------------------
call remove_objects('owner_user','USER');
create user owner_user identified by "netraAwate0987";
grant create session to owner_user;
grant select on read_rental_posting_table to owner_user;
grant select on read_rental_booking_backlog to owner_user;
grant select on READ_RENTAL_COMPLAINT to owner_user;
grant select on READ_RENTAL_FEEDBACK to owner_user;
grant select on VIEW_RENTAL_COMPLAINT to owner_user;
grant execute on UPDATE_RENTAL_COMPLAINT_STATUS to owner_user;
grant select on VIEW_RENTAL_FEEDBACK to owner_user;
grant execute on ADD_OR_UPDATE_RENTAL_POSTING to owner_user;
grant execute on DELETE_RENTAL_POSTING to owner_user;
grant execute on update_owner_details to owner_user;

-- User 4 -----------------------------------------------------------------------------------------------------------------
call remove_objects('admin_user','USER');
create user admin_user identified by "netraAwate0987";
grant create session to admin_user;
grant select on customer to admin_user;
grant select on CUSTOMER_CARD_V to admin_user;
grant select on owner to admin_user;
grant select on read_rental_booking_backlog to admin_user;
grant select on read_rental_complaint to admin_user;
grant select on read_rental_feedback to admin_user;
grant select on read_rental_posting_table to admin_user;
grant execute on sign_up_customer to admin_user;
grant execute on sign_up_owner to admin_user;
grant execute on create_all_tables to admin_user;
grant execute on delete_customer_card_details to admin_user;
grant execute on delete_rental_booking_backlog to admin_user;
grant execute on delete_rental_complaint to admin_user;
grant execute on delete_rental_feedback to admin_user;
grant execute on delete_rental_posting to admin_user;
grant execute on remove_objects to admin_user;
grant execute on update_rental_complaint_status to admin_user;
grant execute on write_credit_card_details to admin_user;
grant execute on write_rental_booking_backlog to admin_user;
grant execute on write_rental_complaint to admin_user;
grant execute on write_rental_feedback to admin_user;