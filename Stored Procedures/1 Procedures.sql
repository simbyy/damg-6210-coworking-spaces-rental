-- Procedures
-- Procedure 1 --------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE remove_objects (
    name_of_object VARCHAR2,
    type_of_object VARCHAR2
) IS
    cnt NUMBER := 0;
BEGIN
    IF upper(type_of_object) = 'TABLE' THEN
        SELECT COUNT(*) INTO cnt FROM user_tables WHERE upper(table_name) = upper(TRIM(name_of_object));
        IF cnt > 0 THEN
            EXECUTE IMMEDIATE 'drop table ' || name_of_object || ' cascade constraints';
        END IF;
    END IF;
    
    IF upper(type_of_object) = 'VIEW' THEN
        SELECT COUNT(*) INTO cnt FROM user_views WHERE upper(view_name) = upper(TRIM(name_of_object));
        IF cnt > 0 THEN
            EXECUTE IMMEDIATE 'drop view ' || name_of_object || ' cascade constraints';
        END IF;
    END IF;

    if upper(type_of_object) = 'USER' then
        select count(*) into cnt from all_users where username = upper(name_of_object);
    if cnt > 0 then          
        execute immediate 'DROP USER '||name_of_object;        
    end if; 
END;

-- Procedure 2 --------------------------------------------------------------------------------------------
create or replace PROCEDURE CREATE_ALL_TABLES AS 
BEGIN
    begin
      execute immediate 'drop table rental_feedback';
    exception
        when others then
            if sqlcode != -942 then
                raise;
            end if;
    end;

    begin
      execute immediate 'drop table rental_complaint';
    exception
        when others then
            if sqlcode != -942 then
                raise;
            end if;
    end;

    begin
      execute immediate 'drop table customer_card_details';
    exception
        when others then
            if sqlcode != -942 then
                raise;
            end if;
    end;

    begin
      execute immediate 'drop table rental_booking_backlog';
    exception
        when others then
            if sqlcode != -942 then
                raise;
            end if;
    end;

    begin
      execute immediate 'drop table rental_posting';
    exception
        when others then
            if sqlcode != -942 then
                raise;
            end if;
    end;

    begin
      execute immediate 'drop table owner';
    exception
        when others then
            if sqlcode != -942 then
                raise;
            end if;
    end;

    begin
      execute immediate 'drop table customer';
    exception
        when others then
            if sqlcode != -942 then
                raise;
            end if;
    end;
    dbms_output.put_line('All tables (if existing) dropped successfully.');

    begin
        execute immediate 'create table customer (
            c_id number(10) primary key,
            c_firstname varchar2(20) not null,
            c_lastname varchar2(20) not null,
            c_email	varchar2(20) not null unique,
            c_contact number(10) not null unique,
            c_username varchar2(10) not null unique,
            c_password varchar2(30)	not null,
            c_city	varchar2(30) not null,
            c_state	varchar2(30) not null,
            c_zipcode varchar2(5) not null,
            c_creationdate date default SYSDATE
        )';
        dbms_output.put_line('Customer table created.');

        execute immediate 'create table owner (
            o_id number(10)	primary key,
            o_firstname varchar2(20) not null,
            o_lastname varchar2(20) not null,
            o_email varchar2(20) not null unique,
            o_contact number not null unique,
            o_username varchar2(10) not null unique,
            o_password varchar2(30) not null,
            o_city  varchar2(30) not null,
            o_state varchar2(30) not null,
            o_zipcode varchar2(5) not null,
            o_creationdate date default SYSDATE
        )';
        dbms_output.put_line('Owner table created.');
        
        execute immediate 'create table rental_posting (
            r_id number(10)	primary key,
            o_id number(10),
            r_type varchar2(6) not null,
            r_rateperhour number(3) not null,
            r_street varchar2(20) not null unique,
            r_city varchar2(30) not null,
            r_state varchar2(30) not null,
            r_zipcode varchar2(5) not null,
            r_creationdate date default SYSDATE,
            r_spotorspace number(1) not null,
            r_totalseatspace number(3) not null,
            r_utilitywifi number(1) not null,
            r_utilitycafeteria number(1) not null,
            r_description varchar2(255) not null,
            r_photo varchar2(100),
            foreign key (o_id) references owner(o_id) on delete cascade
        )';
        dbms_output.put_line('Rental_Posting table created.');

        execute immediate 'create table rental_booking_backlog(
            b_id number(10)	primary key,
            r_id number(10),
            c_id number(10),
            b_startdate	date,
            b_enddate date,
            b_active number(1),
            foreign key (r_id) references rental_posting(r_id) on delete cascade,
            foreign key (c_id) references customer(c_id) on delete cascade
        )';
        dbms_output.put_line('Rental Booking Backlog table created.');

        execute immediate 'create table customer_card_details(
            card_number number(16) primary key,
            c_id number(10),
            card_name varchar2(20) not null,
            card_type varchar2(6) not null,
            card_expirydate varchar2(5) not null,
            card_cvv number(3) not null,
            foreign key (c_id) references customer(c_id) on delete cascade
        )';
        dbms_output.put_line('Customer Card Details table created.');

        execute immediate 'create table rental_complaint(
            complaint_id number(10)	primary key,
            r_id number(10),
            c_id number(10),
            complaint_date date	default SYSDATE,
            complaint_status varchar2(30) not null,
            complaint_description varchar2(255)	not null,
            complaint_severity varchar2(8) not null,
            foreign key (r_id) references rental_posting(r_id) on delete cascade,
            foreign key (c_id) references customer(c_id) on delete cascade
        )';
        dbms_output.put_line('Rental Complaint table created.');
        
        execute immediate 'create table rental_feedback(
            feedback_id number(10) primary key,
            b_id number(10),
            c_id number(10),
            feedback_date date default SYSDATE,
            feedback_review	varchar2(255) not null,
            feedback_rating  number(1) not null,
            foreign key (b_id) references rental_booking_backlog(b_id) on delete cascade,
            foreign key (c_id) references customer(c_id) on delete cascade
        )';
        dbms_output.put_line('Rental Feedback table created.');
        
        --customer table
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(1,''Mark'',''Cuban'',''cuban@gmail.com'',''8769876547'',''cubanRocks'',''Cuban@9876'',''Boston'',''Massachusettes'',''02115'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(2,''Alex'',''Kumar'',''alex@gmail.com'',''8778676547'',''aalexRocks'',''Alex@9876'',''Sacramento'',''California'',''02175'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(3,''Rooney'',''Powell'',''rooney@outlook.edu'',''3786333131'',''rooneRocks'',''Rooney@0987'',''Saint Paul'',''California'',''44787'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(4,''Shelly'',''Mcdaniel'',''cshelly@yahoo.com'',''5723733047'',''ShellRocks'',''Shelly@9876'',''Dayton'', ''Ohio'', ''45440'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(5,''Shelby'',''Savage'',''Shelby@gmail.com'',''5251887926'',''ShelbRocks'',''Shelb@9876'',''Seattle'', ''Washington'', ''98104'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(6,''Cairo'',''Kim'',''Cairo@gmail.com'',''7711982880'',''CairoRocks'',''Cairo@9876'',''Fullerton'', ''California'', ''92640'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(7,''Petra'',''Powell'',''petra@gmail.com'',''6426770867'',''PetraRocks'',''Petra@9876'',''Wichita'', ''Kansas'', ''67210'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(8,''Quamar'',''Cuban'',''quamar@gmail.com'',''1218626186'',''QuamaRocks'',''Quamar@9876'',''Seattle'', ''Washington'', ''98104'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(9,''Daria'',''Savage'',''daria@gmail.com'',''3217172671'',''DariaRocks'',''Daria@9876'',''Fullerton'', ''California'', ''92640'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(10,''Gregory'',''Kim'',''gregory@gmail.com'',''5460597124'',''GregoRocks'',''Gregory@9876'',''Arlington'', ''Texas'', ''76004'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(11,''Noel'',''Powell'',''Noel@gmail.com'',''1886127445'',''NoelRocks'',''Noel@9876'',''Wichita'', ''Kansas'', ''67210'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(12,''Paul'',''Duke'',''Paul@gmail.com'',''7838414848'',''PaulRocks'',''Paul@9876'',''Arlington'', ''Texas'', ''76004'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(13,''Melyssa'',''Joyner'',''Melyssa@gmail.com'',''6214105836'',''MelysRocks'',''Melyssa@9876'',''Dayton'', ''Ohio'', ''45440'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(14,''Levi'',''Shaffer'',''Levi@gmail.com'',''7024450255'',''LeviRocks'',''Levi@9876'',''Seattle'', ''Washington'', ''98104'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(15,''Dustin'',''Savage'',''Dustin@gmail.com'',''6034766322'',''DustiRocks'',''Dustin@9876'',''Fullerton'', ''California'', ''92640'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(16,''Fay'',''Thornton'',''Fay@gmail.com'',''8942145478'',''FayRocks'',''Fay@9876'',''Wichita'', ''Kansas'', ''67210'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(17,''Kato'',''Joyner'',''Kato@gmail.com'',''5142574223'',''KatoRocks'',''Kato@9876'',''Dayton'', ''Ohio'', ''45440'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(18,''Kylynn'',''Moon'',''Kylynn@gmail.com'',''8815685137'',''KylynRocks'',''Kylynn@9876'',''Seattle'', ''Washington'', ''98104'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(19,''Amy'',''Douglas'',''Amy@gmail.com'',''3666225937'',''AmyRocks'',''Amy@9876'',''Fullerton'', ''California'', ''92640'')';
        execute immediate 'INSERT INTO CUSTOMER (c_id,c_firstname,c_lastname,c_email,c_contact,c_username,c_password,c_city,c_state,c_zipcode) VALUES(20,''Denton'',''King'',''Denton@gmail.com'',''4362335560'',''DentoRocks'',''Denton@9876'',''Arlington'', ''Texas'', ''76004'')';
        dbms_output.put_line('Customer table populated.');
        
        --owner table
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(1,''Shayne'',''Gheorghescu'',''Shayne@gmail.com'',''6141541313'',''ShaynRocks'',''Shayne@9876'',''Boston'',''Massachusettes'',''02115'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(2,''Ursa'',''Jaslem'',''Ursa@gmail.com'',''9887442590'',''UrsaRocks'',''Ursa@9876'',''Boston'',''Massachusettes'',''02115'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(3,''Hadleigh'',''Odcroft'',''Hadle@gmail.com'',''7637748484'',''HadleRocks'',''Hadle@9876'',''Fullerton'',''California'',''92640'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(4,''Jana'',''Edmonston'',''Jana@gmail.com'',''6173158419'',''JanaRocks'',''Jana@9876'',''Seattle'',''Washington'',''98104'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(5,''Lori'',''Peartree'',''Lori@gmail.com'',''5682797905'',''LoriRocks'',''Lori@9876'',''Wichita'',''Kansas'',''67210'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(6,''Josias'',''Ganley'',''Josi@gmail.com'',''9998665936'',''JosiRocks'',''Josi@9876'',''Sacramento'',''California'',''02175'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(7,''Flori'', ''Jerrom'',''Flori@gmail.com'',''9382528071'',''FloriRocks'',''Flori@9876'',''Seattle'',''Washington'',''98104'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(8,''Cole'', ''Shurrocks'',''Cole@gmail.com'',''4339923209'',''ColeRocks'',''Cole@9876'',''Fullerton'',''California'',''92640'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(9,''Betty'', ''Sawdy'',''Betty@gmail.com'',''8104556307'',''BettyRocks'',''Betty@9876'',''Seattle'',''Washington'',''98104'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(10,''Evangelin'', ''Arnell'',''Evan@gmail.com'',''9933793839'',''EvanRocks'',''Evan@9876'',''Saint Paul'',''California'',''44787'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(11,''Aloin'', ''Figura'',''Aloin@gmail.com'',''6612751527'',''AloinRocks'',''Aloin@9876'',''Wichita'',''Kansas'',''67210'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(12,''Bran'', ''Alekseicik'',''Bran@gmail.com'',''4452196871'',''BranRocks'',''Bran@9876'',''Saint Paul'',''California'',''44787'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(13,''Torrie'', ''Aurelius'',''torri@gmail.com'',''3904617551'',''TorriRocks'',''Torrie@9876'',''Seattle'',''Washington'',''98104'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(14,''Michele'', ''Perrie'',''Mich@gmail.com'',''1848208226'',''MichRocks'',''Michele@9876'',''Fullerton'',''California'',''92640'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(15,''Britta'', ''Matyja'',''Britt@gmail.com'',''3135830501'',''BrittRocks'',''Britta@9876'',''Seattle'',''Washington'',''98104'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(16,''Halette'', ''Betterton'',''Halet@gmail.com'',''7935640440'',''HaletRocks'',''Halette@9876'',''Seattle'',''Washington'',''98104'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(17,''Udale'', ''Palliser'',''Udale@gmail.com'',''4025322853'',''UdaleRocks'',''Udale@9876'',''Fullerton'',''California'',''92640'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(18,''Ellery'', ''Wixey'',''Eller@gmail.com'',''8817691512'',''EllerRocks'',''Ellery@9876'',''Seattle'',''Washington'',''98104'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(19,''Corrina'', ''Barnhart'',''Corri@gmail.com'',''3563128570'',''CorriRocks'',''Corrina@9876'',''Wichita'',''Kansas'',''67210'')';
        execute immediate 'INSERT INTO OWNER (O_id,O_firstname,O_lastname,O_email,O_contact,O_username,O_password,O_city,O_state,O_zipcode) VALUES(20,''Bellanca'', ''Degnen'',''Bella@gmail.com'',''8426890374'',''BellaRocks'',''Bellanca@9876'',''Saint Paul'',''California'',''44787'')';
        dbms_output.put_line('Owner table populated.');
        
        --rental posting table
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(1,''1'',''Studio'',''50'',''9610 Amet, St.'',''Boston'',''Massachusettes'',''02115'',SYSDATE,''1'',''20'',''1'',''1'',''Affordable studio space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(2,''2'',''Office'',''80'',''3412 Purus. St.'',''Boston'',''Massachusettes'',''02115'',SYSDATE,''1'',''50'',''1'',''1'',''Spacious office space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(3,''3'',''Cafe'',''30'',''172-7719 Nec Street'',''Fullerton'',''California'',''92640'',SYSDATE,''1'',''20'',''1'',''1'',''Cool cafe space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(4,''4'',''Cafe'',''40'',''4356 Tincidunt Road'',''Seattle'',''Washington'',''98104'',SYSDATE,''1'',''10'',''1'',''1'',''Affordable cafe space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(5,''5'',''Studio'',''50'',''2731 Nec Rd.'',''Wichita'',''Kansas'',''67210'',SYSDATE,''1'',''20'',''1'',''1'',''Affordable studio space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(6,''6'',''Office'',''80'',''9416 Angeline Park'',''Sacramento'',''California'',''02175'',SYSDATE,''1'',''50'',''1'',''1'',''Spacious office space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(7,''7'',''Cafe'',''30'',''Kirlin Drive Apt.'',''Seattle'',''Washington'',''98104'',SYSDATE,''1'',''20'',''1'',''1'',''Cool cafe space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(8,''8'',''Cafe'',''40'',''ena Curve Suite'',''Fullerton'',''California'',''92640'',SYSDATE,''1'',''10'',''1'',''1'',''Affordable cafe space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(9,''9'',''Cafe'',''20'',''Scelerisque Rd.'',''Seattle'',''Washington'',''98104'',SYSDATE,''1'',''10'',''1'',''1'',''Affordable cafe space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(10,''10'',''Studio'',''45'',''Imperdiet St.'',''Saint Paul'',''California'',''44787'',SYSDATE,''1'',''20'',''0'',''1'',''Affordable studio space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(11,''11'',''Office'',''70'',''499 Elit, Road'',''Wichita'',''Kansas'',''67210'',SYSDATE,''0'',''1'',''1'',''0'',''Spacious office space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(12,''12'',''Cafe'',''20'',''Libero. Road'',''Saint Paul'',''California'',''44787'',SYSDATE,''0'',''1'',''1'',''1'',''Cool cafe space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(13,''13'',''Cafe'',''90'',''281-5609 Ac Rd.'',''Seattle'',''Washington'',''98104'',SYSDATE,''1'',''10'',''1'',''1'',''Affordable cafe space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(14,''14'',''Cafe'',''60'',''Vitae Street'',''Fullerton'',''California'',''92640'',SYSDATE,''0'',''1'',''0'',''1'',''Affordable cafe space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(15,''15'',''Studio'',''25'',''Lorem St.'',''Seattle'',''Washington'',''98104'',SYSDATE,''1'',''65'',''0'',''0'',''Affordable studio space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(16,''16'',''Office'',''150'',''Tortor Street'',''Seattle'',''Washington'',''98104'',SYSDATE,''0'',''1'',''1'',''0'',''Spacious office space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(17,''17'',''Cafe'',''40'',''Ante Street'',''Fullerton'',''California'',''92640'',SYSDATE,''0'',''1'',''1'',''1'',''Cool cafe space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(18,''18'',''Cafe'',''90'',''Ipsum. Street'',''Seattle'',''Washington'',''98104'',SYSDATE,''1'',''5'',''1'',''0'',''Affordable cafe space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(19,''19'',''Office'',''110'',''Quis, Rd.'',''Wichita'',''Kansas'',''67210'',SYSDATE,''1'',''5'',''1'',''0'',''Spacious office space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        execute immediate 'INSERT INTO rental_posting (R_ID,O_ID,R_TYPE,R_RATEPERHOUR,R_STREET,R_CITY,R_STATE,R_ZIPCODE,R_CREATIONDATE,R_SPOTORSPACE,R_TOTALSEATSPACE,R_UTILITYWIFI,R_UTILITYCAFETERIA,R_DESCRIPTION,R_PHOTO) VALUES(20,''20'',''Cafe'',''80'',''Velit Road'',''Saint Paul'',''California'',''44787'',SYSDATE,''0'',''1'',''1'',''1'',''Cool cafe space for those looking to escape the isolation of a home office or coffee shop'',''IMAGE URL'')';
        dbms_output.put_line('Rental Posting table populated.');
        
        --rental booking backlog table
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(1, ''1'',''1'',''17-APR-22'',''17-APR-22'',''1'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(2, ''2'',''1'',''18-APR-22'',''18-APR-22'',''0'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(3, ''1'',''2'',''18-APR-22'',''18-APR-22'',''1'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(4, ''4'',''2'',''19-APR-22'',''19-APR-22'',''0'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(5, ''8'',''6'',''17-APR-22'',''17-APR-22'',''0'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(6, ''5'',''6'',''17-APR-22'',''17-APR-22'',''1'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(7, ''1'',''6'',''19-APR-22'',''19-APR-22'',''0'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(8, ''5'',''7'',''17-APR-22'',''17-APR-22'',''0'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(9, ''9'',''7'',''17-APR-22'',''17-APR-22'',''1'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(10, ''1'',''7'',''19-APR-22'',''19-APR-22'',''0'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(11, ''5'',''3'',''20-APR-22'',''20-APR-22'',''0'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(12, ''9'',''3'',''17-APR-22'',''17-APR-22'',''0'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(13, ''15'',''3'',''21-APR-22'',''21-APR-22'',''1'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(14, ''12'',''14'',''20-APR-22'',''20-APR-22'',''1'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(15, ''10'',''19'',''17-APR-22'',''17-APR-22'',''1'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(16, ''11'',''11'',''21-APR-22'',''21-APR-22'',''1'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(17, ''12'',''4'',''20-APR-22'',''20-APR-22'',''0'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(18, ''6'',''19'',''17-APR-22'',''17-APR-22'',''0'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(19, ''11'',''4'',''20-APR-22'',''20-APR-22'',''1'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(20, ''13'',''12'',''20-APR-22'',''20-APR-22'',''1'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(21, ''14'',''17'',''17-APR-22'',''17-APR-22'',''1'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(22, ''15'',''16'',''20-APR-22'',''20-APR-22'',''1'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(23, ''6'',''18'',''17-APR-22'',''17-APR-22'',''0'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(24, ''11'',''13'',''20-APR-22'',''20-APR-22'',''0'')';
        execute immediate 'INSERT INTO RENTAL_BOOKING_BACKLOG(B_ID,R_ID,C_ID,B_STARTDATE,B_ENDDATE,B_ACTIVE) VALUES(25, ''13'',''20'',''20-APR-22'',''20-APR-22'',''0'')';
        dbms_output.put_line('Rental Booking Backlog table populated.');
        
        --credit card table
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''2221239531707878'',1,''Mark Cuban'',''Visa'',''03/23'',''878'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''4539358319678771'',2,''Alex Kumar'',''Visa'',''02/23'',''878'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''4916984470654708'',3,''Rooney Powell'',''Visa'',''12/24'',''491'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''5166690163563288'',4,''Shelly Mcdaniel'',''Visa'',''01/25'',''471'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''5585852458737133'',5,''Shelby Savage'',''Visa'',''05/23'',''451'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''5280223268369939'',6,''Cairo Kim'',''Visa'',''03/25'',''494'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''2308684869268983'',7,''Petra Powell'',''Visa'',''12/26'',''493'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''3589438209573364'',8,''Quamar Cuban'',''JCB'',''11/23'',''494'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''4916513643344234'',9,''Daria Savage'',''Visa'',''11/26'',''393'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''2221755594185900'',10,''Gregory Kim'',''Visa'',''12/25'',''263'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''4716467798057111'',11,''Noel Powell'',''Visa'',''10/23'',''733'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''5144684205976159'',12,''Paul Duke'',''JCB'',''11/23'',''414'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''2667088056855161'',13,''Melyssa Joyner'',''Visa'',''11/26'',''323'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''3589925416706209'',14,''Levi Shaffer'',''Visa'',''12/25'',''233'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''6011662921484615'',15,''Dustin Savage'',''Visa'',''10/23'',''743'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''2645342450044618'',16,''Fay Thornton'',''Visa'',''09/23'',''733'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''5217233707464223'',17,''Kato Joyner'',''JCB'',''11/24'',''414'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''4556268706189670'',18,''Kylynn Moon'',''Visa'',''11/26'',''323'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''2621020057520747'',19,''Amy Douglas'',''JCB'',''03/23'',''233'')';
        execute immediate 'INSERT INTO CUSTOMER_CARD_DETAILS (CARD_NUMBER, C_ID,CARD_NAME, CARD_TYPE, CARD_EXPIRYDATE, CARD_CVV) VALUES(''6726514083687038'',20,''Denton King'',''Visa'',''01/23'',''143'')';
        dbms_output.put_line('Customer Card Details table populated.');
        
        --rental feedback table
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(1, ''1'',''1'',''18-APR-22'',''Very comfortable workplace with great ambience and pleasant work culture'',5)';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(2, ''6'',''6'',''19-APR-22'',''Highly recommend this place to budding entrepreneurs and people looking for a comfortable place to work.'',4)';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(3, ''9'',''7'',''18-APR-22'',''Using it, loved it. Perfect place for entrepreneurs'',4)';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(4, ''22'',''16'',''18-APR-22'',''Co- Working space. Great environment. Great place for team members'',3)';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(5, ''20'',''12'',''21-APR-22'',''Wifi network is not good to work with'',2)';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(6, ''15'',''19'',''18-APR-22'',''Very noisy due to construction on the roadside'',5)';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(7, ''21'',''17'',''18-APR-22'',''overall positive experience'',4)';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(8, ''13'',''3'',''22-APR-22'',''Take your own coffe to work'',3)';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(9, ''3'',''2'',''18-APR-22'',''overall positive experience'',2)';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(10, ''14'',''14'',''18-APR-22'',''Ambience is not productive'',4)';
        dbms_output.put_line('Rental Feedback table populated.');
        
        --rental complaint table
        execute immediate 'INSERT INTO RENTAL_COMPLAINT(COMPLAINT_ID,R_ID,C_ID,COMPLAINT_DATE,COMPLAINT_STATUS,COMPLAINT_DESCRIPTION,COMPLAINT_SEVERITY) VALUES(1, ''1'',''1'',''19-APR-22'',''CREATED'',''WIFI WAS NOT WORKING PORPERLY'',''MEDIUM'')';
        execute immediate 'INSERT INTO RENTAL_COMPLAINT(COMPLAINT_ID,R_ID,C_ID,COMPLAINT_DATE,COMPLAINT_STATUS,COMPLAINT_DESCRIPTION,COMPLAINT_SEVERITY) VALUES(2, ''1'',''2'',''18-APR-22'',''CREATED'',''ELECTRICITY FLUCTUATIONS'',''HIGH'')';
        execute immediate 'INSERT INTO RENTAL_COMPLAINT(COMPLAINT_ID,R_ID,C_ID,COMPLAINT_DATE,COMPLAINT_STATUS,COMPLAINT_DESCRIPTION,COMPLAINT_SEVERITY) VALUES(3, ''5'',''6'',''17-APR-22'',''ACKNOWLEDGED BY OWNER'',''BROKEN COFFE MACHINE'',''LOW'')';
        execute immediate 'INSERT INTO RENTAL_COMPLAINT(COMPLAINT_ID,R_ID,C_ID,COMPLAINT_DATE,COMPLAINT_STATUS,COMPLAINT_DESCRIPTION,COMPLAINT_SEVERITY) VALUES(4, ''15'',''16'',''21-APR-22'',''CREATED'',''PRINTER NOT WORKING'',''MEDIUM'')';
        execute immediate 'INSERT INTO RENTAL_COMPLAINT(COMPLAINT_ID,R_ID,C_ID,COMPLAINT_DATE,COMPLAINT_STATUS,COMPLAINT_DESCRIPTION,COMPLAINT_SEVERITY) VALUES(5, ''9'',''7'',''20-APR-22'',''RESOLVED'',''REFILL PEN AND PENCILS'',''HIGH'')';
        execute immediate 'INSERT INTO RENTAL_COMPLAINT(COMPLAINT_ID,R_ID,C_ID,COMPLAINT_DATE,COMPLAINT_STATUS,COMPLAINT_DESCRIPTION,COMPLAINT_SEVERITY) VALUES(6, ''11'',''11'',''21-APR-22'',''ACKNOWLEDGED BY OWNER'',''PUT PROPER NUMBER TAGS ON SEATS'',''HIGH'')';
        execute immediate 'INSERT INTO RENTAL_COMPLAINT(COMPLAINT_ID,R_ID,C_ID,COMPLAINT_DATE,COMPLAINT_STATUS,COMPLAINT_DESCRIPTION,COMPLAINT_SEVERITY) VALUES(7, ''12'',''14'',''21-APR-22'',''CREATED'',''BACKGROUND MUSIC IS VERY HIGH IN VOLUMNE'',''HIGH'')';
        execute immediate 'INSERT INTO RENTAL_COMPLAINT(COMPLAINT_ID,R_ID,C_ID,COMPLAINT_DATE,COMPLAINT_STATUS,COMPLAINT_DESCRIPTION,COMPLAINT_SEVERITY) VALUES(8, ''13'',''12'',''22-APR-22'',''ACKNOWLEDGED BY OWNER'',''CHAIRS ARE BROKEN'',''MEDIUM'')';
        execute immediate 'INSERT INTO RENTAL_COMPLAINT(COMPLAINT_ID,R_ID,C_ID,COMPLAINT_DATE,COMPLAINT_STATUS,COMPLAINT_DESCRIPTION,COMPLAINT_SEVERITY) VALUES(9, ''10'',''19'',''20-APR-22'',''RESOLVED'',''FIX AIR CONDITIONER'',''HIGH'')';
        execute immediate 'INSERT INTO RENTAL_COMPLAINT(COMPLAINT_ID,R_ID,C_ID,COMPLAINT_DATE,COMPLAINT_STATUS,COMPLAINT_DESCRIPTION,COMPLAINT_SEVERITY) VALUES(10, ''14'',''17'',''19-APR-22'',''RESOLVED'',''REPLACE WATER COOLER'',''MEDIUM'')';
        dbms_output.put_line('Rental Complaint table populated.');
        
    end;
END CREATE_ALL_TABLES;

-- Procedure 3 --------------------------------------------------------------------------------------------

create or replace PROCEDURE DELETE_CUSTOMER_CARD_DETAILS 
(
  CID VARCHAR2 
) AS
BEGIN
    DECLARE
        cid_e exception;
        cid_flag numeric;
    BEGIN
        select count(*) into cid_flag from customer_card_details where c_id = cid;
        CASE
            WHEN cid_flag is null then raise cid_e;
            ELSE null;
        END CASE;
        delete from customer_card_details where c_id = cid;
    EXCEPTION
        WHEN cid_e THEN RAISE_APPLICATION_ERROR (-20013, 'Please enter valid customer id.');
    END;
END DELETE_CUSTOMER_CARD_DETAILS;

-- Procedure 4 ---------------------------------------------------------------------------------------------

create or replace PROCEDURE DELETE_RENTAL_BOOKING_BACKLOG (
    BID numeric
) AS 
BEGIN
    DECLARE
        bid_e exception;
        bid_flag numeric;
    BEGIN
        select count(*) into bid_flag from rental_booking_backlog where b_id = bid;
        CASE
            WHEN bid_flag is null then raise bid_e;
            ELSE null;
        END CASE;
        update rental_booking_backlog set b_active = 0 where b_id = bid;
    EXCEPTION
        WHEN bid_e THEN RAISE_APPLICATION_ERROR (-20006, 'Please enter valid booking id.');
    END;
END DELETE_RENTAL_BOOKING_BACKLOG;

-- Procedure 5 --------------------------------------------------------------------------------------------

create or replace PROCEDURE DELETE_RENTAL_COMPLAINT 
(
  COMP_ID IN numeric 
) AS 
BEGIN
  DECLARE
        compid_e exception;
        compid_flag numeric;
    BEGIN
        select count(*) into compid_flag from rental_complaint where complaint_id = comp_id;
        CASE
            WHEN compid_flag is null then raise compid_e;
            ELSE null;
        END CASE;
        delete from rental_complaint where complaint_id = comp_id;
    EXCEPTION
        WHEN compid_e THEN RAISE_APPLICATION_ERROR (-20019, 'Please enter valid complaint id.');
    END;
END DELETE_RENTAL_COMPLAINT;

-- Procedure 6 -------------------------------------------------------------------------------------------

create or replace PROCEDURE DELETE_RENTAL_FEEDBACK 
(
  FB_ID IN NUMBER 
) AS 
BEGIN
  DECLARE
        fbid_e exception;
        fbid_flag numeric;
    BEGIN
        select count(*) into fbid_flag from rental_feedback where feedback_id = fb_id;
        CASE
            WHEN fbid_flag is null then raise fbid_e;
            ELSE null;
        END CASE;
        delete from rental_feedback where feedback_id = fb_id;
    EXCEPTION
        WHEN fbid_e THEN RAISE_APPLICATION_ERROR (-20024, 'Please enter valid feedback id.');
    END;
END DELETE_RENTAL_FEEDBACK;

-- Procedure 7 --------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE DELETE_RENTAL_POSTING 
(
  RID IN NUMBER 
) AS 
BEGIN
  DECLARE
        rid_e exception;
        rid_flag numeric;
    BEGIN
        select count(*) into rid_flag from rental_posting where r_id = rid;
        CASE
            WHEN rid_flag is null then raise rid_e;
            ELSE null;
        END CASE;
        delete from rental_posting where r_id = rid;
    EXCEPTION
        WHEN rid_e THEN RAISE_APPLICATION_ERROR (-20024, 'Please enter valid rental id.');
    END;
END DELETE_RENTAL_POSTING;

-- Procedure 8 --------------------------------------------------------------------------------------------

create or replace PROCEDURE SIGN_UP_CUSTOMER 
(
  FIRST_NAME IN VARCHAR2 
, LAST_NAME IN VARCHAR2 
, EMAIL IN VARCHAR2 
, CONTACT IN NUMBER 
, USERNAME IN VARCHAR2 
, PASSWRD IN VARCHAR2 
, CITY IN VARCHAR2 
, C_STATE IN VARCHAR2 
, ZIP_CODE IN VARCHAR2 
) AS 
cust_id numeric;
cur_date date;
existing_email_flag numeric;
existing_contact_flag numeric;
existing_username_flag numeric;

BEGIN
    DECLARE
        null_fname_e exception;
        null_lname_e exception;
        null_email_e exception;
        existing_email_e exception;
        invalid_email_e exception;
        null_contact_e exception;
        existing_contact_e exception;
        null_username_e exception;
        existing_username_e exception;
        null_password_e exception;
        null_city_e exception;
        null_state_e exception;
        null_zipcode_e exception;
        invalid_zipcode_e exception;
    BEGIN
        select max(c_id)+1 into cust_id from customer;
        select count(*) into existing_email_flag from customer where c_email=EMAIL;
        select count(*) into existing_contact_flag from customer where c_contact=CONTACT;
        select count(*) into existing_username_flag from customer where c_username=USERNAME;
        
        CASE
            WHEN FIRST_NAME is null then raise null_fname_e;
            WHEN LAST_NAME is null then raise null_lname_e;
            WHEN EMAIL is null then raise null_email_e;
            WHEN CONTACT is null then raise null_contact_e;
            WHEN USERNAME is null then raise null_username_e;
            WHEN PASSWRD is null then raise null_password_e;
            WHEN CITY is null then raise null_city_e;
            WHEN C_STATE is null then raise null_state_e;
            WHEN ZIP_CODE is null then raise null_zipcode_e;
            WHEN existing_email_flag!=0 then raise existing_email_e;
            WHEN existing_contact_flag!=0 then raise existing_contact_e;
            WHEN existing_username_flag!=0 then raise existing_username_e;
            WHEN EMAIL not like ('%@%.%') then raise invalid_email_e;
            WHEN length(ZIP_CODE)!=5 then raise invalid_zipcode_e;
            WHEN not REGEXP_LIKE(ZIP_CODE, '^[[:digit:]]+$') then raise invalid_zipcode_e;
            ELSE null;
        END CASE;
        
        select sysdate into cur_date from dual;
        insert into customer values(cust_id, first_name, last_name, email, contact, username, passwrd, city, c_state, zip_code, cur_date);
        DBMS_OUTPUT.put_line('Customer added.');
        
        EXCEPTION 
            WHEN null_fname_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for first name. Please re-enter.'); 
         
            WHEN null_lname_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for last name. Please re-enter.');  
            
            WHEN null_email_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for email. Please re-enter.'); 
                        
            WHEN null_contact_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for contact. Please re-enter.'); 
                        
            WHEN null_username_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for username. Please re-enter.'); 
                        
            WHEN null_password_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for password. Please re-enter.'); 
                        
            WHEN null_city_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for city. Please re-enter.'); 
                        
            WHEN null_state_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for state. Please re-enter.');
                        
            WHEN null_zipcode_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for zip code. Please re-enter.'); 
                        
            WHEN existing_email_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20002, 
                        'This email address is already in use. Please log in to existing account or use another email.'); 
                        
            WHEN existing_contact_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20002, 
                        'This contact number is already in use. Please log in to existing account or use another contact number.'); 
                        
            WHEN existing_username_e
                THEN
                    RAISE_APPLICATION_ERROR (-20002,
                        'This username is already in use. Please log in to existing account or use another username.');
                        
            WHEN invalid_email_e
                THEN
                    RAISE_APPLICATION_ERROR(-20003,
                        'Invalid email address was provided. Please re-enter.');
                        
            WHEN invalid_zipcode_e
                THEN
                    RAISE_APPLICATION_ERROR(-20003,
                        'Invalid zip code was provided. Please re-enter.');
            
    END;
END SIGN_UP_CUSTOMER;

-- Procedure 9 ---------------------------------------------------------------------------------------------

create or replace PROCEDURE SIGN_UP_OWNER 
(
  FIRST_NAME IN VARCHAR2 
, LAST_NAME IN VARCHAR2 
, EMAIL IN VARCHAR2 
, CONTACT IN NUMBER 
, USERNAME IN VARCHAR2 
, PASSWRD IN VARCHAR2 
, CITY IN VARCHAR2 
, C_STATE IN VARCHAR2 
, ZIP_CODE IN VARCHAR2 
) AS 
owner_id numeric;
cur_date date;
existing_email_flag numeric;
existing_contact_flag numeric;
existing_username_flag numeric;

BEGIN
    DECLARE
        null_fname_e exception;
        null_lname_e exception;
        null_email_e exception;
        existing_email_e exception;
        invalid_email_e exception;
        null_contact_e exception;
        existing_contact_e exception;
        null_username_e exception;
        existing_username_e exception;
        null_password_e exception;
        null_city_e exception;
        null_state_e exception;
        null_zipcode_e exception;
        invalid_zipcode_e exception;
    BEGIN
        select max(o_id)+1 into owner_id from owner;
        select count(*) into existing_email_flag from owner where o_email=EMAIL;
        select count(*) into existing_contact_flag from owner where o_contact=CONTACT;
        select count(*) into existing_username_flag from owner where o_username=USERNAME;
        
        CASE
            WHEN FIRST_NAME is null then raise null_fname_e;
            WHEN LAST_NAME is null then raise null_lname_e;
            WHEN EMAIL is null then raise null_email_e;
            WHEN CONTACT is null then raise null_contact_e;
            WHEN USERNAME is null then raise null_username_e;
            WHEN PASSWRD is null then raise null_password_e;
            WHEN CITY is null then raise null_city_e;
            WHEN C_STATE is null then raise null_state_e;
            WHEN ZIP_CODE is null then raise null_zipcode_e;
            WHEN existing_email_flag!=0 then raise existing_email_e;
            WHEN existing_contact_flag!=0 then raise existing_contact_e;
            WHEN existing_username_flag!=0 then raise existing_username_e;
            WHEN EMAIL not like ('%@%.%') then raise invalid_email_e;
            WHEN length(ZIP_CODE)!=5 then raise invalid_zipcode_e;
            WHEN not REGEXP_LIKE(ZIP_CODE, '^[[:digit:]]+$') then raise invalid_zipcode_e;
            ELSE null;
        END CASE;
        
        select sysdate into cur_date from dual;
        insert into owner values(owner_id, first_name, last_name, email, contact, username, passwrd, city, c_state, zip_code, cur_date);
        DBMS_OUTPUT.put_line('Owner added.');
        
        EXCEPTION 
            WHEN null_fname_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for first name. Please re-enter.'); 
         
            WHEN null_lname_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for last name. Please re-enter.');  
            
            WHEN null_email_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for email. Please re-enter.'); 
                        
            WHEN null_contact_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for contact. Please re-enter.'); 
                        
            WHEN null_username_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for username. Please re-enter.'); 
                        
            WHEN null_password_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for password. Please re-enter.'); 
                        
            WHEN null_city_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for city. Please re-enter.'); 
                        
            WHEN null_state_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for state. Please re-enter.');
                        
            WHEN null_zipcode_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20001, 
                        'Null values and empty strings are not allowed for zip code. Please re-enter.'); 
                        
            WHEN existing_email_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20002, 
                        'This email address is already in use. Please log in to existing account or use another email.'); 
                        
            WHEN existing_contact_e 
                THEN  
                    RAISE_APPLICATION_ERROR (-20002, 
                        'This contact number is already in use. Please log in to existing account or use another contact number.'); 
                        
            WHEN existing_username_e
                THEN
                    RAISE_APPLICATION_ERROR (-20002,
                        'This username is already in use. Please log in to existing account or use another username.');
                        
            WHEN invalid_email_e
                THEN
                    RAISE_APPLICATION_ERROR(-20003,
                        'Invalid email address was provided. Please re-enter.');
                        
            WHEN invalid_zipcode_e
                THEN
                    RAISE_APPLICATION_ERROR(-20003,
                        'Invalid zip code was provided. Please re-enter.');
            
    END;
END SIGN_UP_OWNER;

-- Procedure 10 --------------------------------------------------------------------------------------------

create or replace PROCEDURE UPDATE_RENTAL_COMPLAINT_STATUS 
( comp_id in numeric, status IN VARCHAR2
) AS 
BEGIN
    declare
        status_e exception;
        complaintid numeric;
        complaintid_e exception;
    begin
        select count(*) into complaintid from rental_complaint where complaint_id = comp_id;
        case
            when status is null then raise status_e;
            when complaintid is null then raise complaintid_e;
            else null;
        end case;
        update rental_complaint set complaint_status = status where complaint_id = comp_id;
    exception
        when status_e then RAISE_APPLICATION_ERROR (-20018, 'Please enter valid status information.');
        when complaintid_e then RAISE_APPLICATION_ERROR (-20019, 'Please enter valid complaint id.');
    end;
END UPDATE_RENTAL_COMPLAINT_STATUS;

-- Procedure 11 --------------------------------------------------------------------------------------------

create or replace PROCEDURE WRITE_CREDIT_CARD_DETAILS 
(
  CARDNUMBER IN NUMBER 
, CID IN NUMBER 
, CVV IN NUMBER 
, c_NAME IN VARCHAR2 
, c_TYPE IN VARCHAR2 
, EXPIRY IN VARCHAR2 
) AS 
BEGIN
  declare
    cid_e exception;
    cnumber_e exception;
    cvv_e exception;
    name_e exception;
    type_e exception;
    expiry_e exception;
    cid_flag numeric;
  begin
    select count(*) into cid_flag from customer where c_id = cid;
    case
        when cid_flag is null then raise cid_e;
        when cid is null then raise cid_e;
        when cardnumber is null then raise cnumber_e;
        when cardnumber<1000000000000000 then raise cnumber_e;
        when cardnumber>9999999999999999 then raise cnumber_e;
        when cvv is null then raise cvv_e;
        when cvv<100 then raise cvv_e;
        when cvv>999 then raise cvv_e;
        when c_type is null then raise type_e;
        when lower(c_type)!='credit' and lower(c_type)!='debit' then raise type_e;
        when expiry is null then raise expiry_e;
        when expiry not like '__/2_' then raise expiry_e;
        else null;
    end case;
    insert into customer_card_details values (cardnumber, cid, c_name, c_type, expiry, cvv);
  exception
    when cid_e then RAISE_APPLICATION_ERROR (-20007, 'Please enter valid customer id.');
    when cnumber_e then RAISE_APPLICATION_ERROR (-20008, 'Please enter valid card number.');
    when cvv_e then RAISE_APPLICATION_ERROR (-20009, 'Please enter valid cvv number.');
    when type_e then RAISE_APPLICATION_ERROR (-20010, 'Please enter valid card type from "credit" or "debit".');
    when expiry_e then RAISE_APPLICATION_ERROR (-20011, 'Please enter valid expiry date in mm/yy format.');
  end;
END WRITE_CREDIT_CARD_DETAILS;

-- Procedure 12 --------------------------------------------------------------------------------------------

create or replace PROCEDURE WRITE_RENTAL_BOOKING_BACKLOG 
(
  RID IN NUMBER 
, CID IN NUMBER 
, B_START IN DATE 
, B_END IN DATE
) AS 
BEGIN
    DECLARE
        rid_e exception;
        cid_e exception;
        bstart_e exception;
        bend_e exception;
        rid_flag numeric;
        cid_flag numeric;
        bid numeric;
    BEGIN
        select count(*) into rid_flag from rental_posting where r_id = rid;
        select count(*) into cid_flag from customer where c_id = cid;
        select max(b_id)+1 into bid from rental_booking_backlog;
        CASE
            WHEN rid is null then raise rid_e;
            WHEN cid is null then raise cid_e;
            WHEN b_start is null then raise bstart_e;
            WHEN b_end is null then raise bend_e;
            WHEN rid_flag is null then raise rid_e;
            WHEN cid_flag is null then raise cid_e;
            ELSE null;
        END CASE;
        insert into rental_booking_backlog values(bid, rid, cid, b_start, b_end, 1);
    EXCEPTION
        WHEN rid_e THEN
                    RAISE_APPLICATION_ERROR (-20005, 'Please enter valid rental id.');
        WHEN cid_e THEN
                    RAISE_APPLICATION_ERROR (-20005, 'Please enter valid customer id.');
        WHEN bstart_e THEN
                    RAISE_APPLICATION_ERROR (-20005, 'Please enter valid start date.');
        WHEN bend_e THEN
                    RAISE_APPLICATION_ERROR (-20005, 'Please enter valid end date.');
    END;
END WRITE_RENTAL_BOOKING_BACKLOG;

-- Procedure 13 --------------------------------------------------------------------------------------------

create or replace PROCEDURE WRITE_RENTAL_COMPLAINT 
(
  RID IN NUMBER 
, CID IN NUMBER 
, COMPLAINTDESC IN VARCHAR2 
, SEVERITY IN VARCHAR2 
) AS 
BEGIN
    declare
        rid_e exception;
        cid_e exception;
        complaintdesc_e exception;
        severity_e exception;
        complaintid numeric;
        complaintdate date;
        rid_flag numeric;
        cid_flag numeric;
    begin
        select max(complaint_id)+1 into complaintid from rental_complaint;
        select r_id into rid_flag from rental_posting where r_id = rid;
        select c_id into cid_flag from customer where c_id = cid;
        select sysdate into complaintdate from dual;
        case
            when rid is null then raise rid_e;
            when cid is null then raise cid_e;
            when complaintdesc is null then raise complaintdesc_e;
            when severity is null then raise severity_e;
            when rid_flag is null then raise rid_e;
            when cid_flag is null then raise cid_e;
            when lower(severity)!='low' and lower(severity)!='medium' and lower(severity)!='high' then raise severity_e;
            else null;
        end case;
        insert into rental_complaint values(complaintid, rid, cid, complaintdate, 'created', complaintdesc, severity);
    exception
        when rid_e then RAISE_APPLICATION_ERROR (-20014, 'Please enter valid rental id.');
        when cid_e then RAISE_APPLICATION_ERROR (-20015, 'Please enter valid customer id.');
        when complaintdesc_e then RAISE_APPLICATION_ERROR (-20016, 'Please enter valid complaint description.');
        when severity_e then RAISE_APPLICATION_ERROR (-20017, 'Please enter valid severity from "low", "medium", "high".');
    end;
END WRITE_RENTAL_COMPLAINT;

-- Procedure 14 ---------------------------------------------------------------------------------------------

create or replace PROCEDURE WRITE_RENTAL_FEEDBACK 
(
  BID IN NUMBER 
, CID IN NUMBER 
, REVIEW IN VARCHAR2 
, RATING IN number 
) AS 
BEGIN
    declare
        bid_e exception;
        cid_e exception;
        review_e exception;
        rating_e exception;
        fb_id numeric;
        fb_date date;
        bid_flag numeric;
        cid_flag numeric;
    begin
        select max(feedback_id)+1 into fb_id from rental_feedback;
        select count(*) into bid_flag from rental_booking_backlog where b_id = bid;
        select count(*) into cid_flag from customer where c_id = cid;
        select sysdate into fb_date from dual;
        case
            when bid is null then raise bid_e;
            when cid is null then raise cid_e;
            when review is null then raise review_e;
            when rating is null then raise rating_e;
            when bid_flag is null then raise bid_e;
            when cid_flag is null then raise cid_e;
            when rating<0 or rating>5 then raise rating_e;
            else null;
        end case;
        insert into rental_feedback values(fb_id, bid, cid, fb_date, review, rating);
    exception
        when bid_e then RAISE_APPLICATION_ERROR (-20020, 'Please enter valid booking id.');
        when cid_e then RAISE_APPLICATION_ERROR (-20021, 'Please enter valid customer id.');
        when review_e then RAISE_APPLICATION_ERROR (-20022, 'Please enter valid review.');
        when rating_e then RAISE_APPLICATION_ERROR (-20023, 'Please enter valid rating, between 0 to 5.');
    end;
END WRITE_RENTAL_FEEDBACK;

-- Procedure 15 -----------------------------------------------------------------------------------------------------
create or replace PROCEDURE UPDATE_OWNER_DETAILS 
(
  USERNAME IN VARCHAR2
, PASSWRD IN VARCHAR2
, EMAIL IN VARCHAR2
, CONTACT IN NUMERIC
) AS 
BEGIN
    DECLARE
        invalid_credentials exception;
        invalid_email exception;
        no_parameter exception;
        username_flag numeric;
        password_flag varchar2(30);
    BEGIN
        select count(*) into username_flag from owner where o_username = USERNAME;
        select o_password into password_flag from owner where o_username = USERNAME;
        CASE
            WHEN username_flag is null then raise invalid_credentials;
            WHEN password_flag!=PASSWRD then raise invalid_credentials;
            WHEN (CONTACT is null and EMAIL is null) then raise no_parameter;
            WHEN (EMAIL is not null and EMAIL not like '%@%.%') then raise invalid_email;
            WHEN (EMAIL is not null and CONTACT is not null) then execute immediate 'update owner set o_email = '''||EMAIL||''', o_contact = '||CONTACT||' where o_username = '''||USERNAME||'''';
            WHEN EMAIL is null then execute immediate 'update owner set o_contact = '||CONTACT||' where o_username = '''||USERNAME||'''';
            WHEN CONTACT is null then execute immediate 'update owner set o_email = '''||EMAIL||''' where o_username = '''||USERNAME||'''';
            ELSE null;
        END CASE;

        EXCEPTION
            WHEN invalid_credentials 
                THEN
                    RAISE_APPLICATION_ERROR (-20004, 
                        'Please re-enter credentials. Invalid username or password provided.');
            WHEN no_parameter
                THEN
                    RAISE_APPLICATION_ERROR(-20005,
                        'No email or contact number provided for update. Please re-enter information');
            WHEN invalid_email
                THEN
                    RAISE_APPLICATION_ERROR(-20006,
                        'Invalid email address provided. Please re-enter');
    END;
END UPDATE_OWNER_DETAILS;