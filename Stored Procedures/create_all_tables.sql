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
        
        execute immediate 'create table customer_card_details(
            card_number number(16) primary key,
            c_id number(10),
            card_name varchar2(20) not null,
            card_type varchar2(6) not null,
            card_expirydate varchar2(5) not null,
            card_cvv number(3) not null,
            foreign key (c_id) references customer(c_id) on delete cascade
        )';
        
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
        
        --rental feedback table
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(1, ''1'',''1'',''18-APR-22'',''Very comfortable workplace with great ambience and pleasant work culture'',''1'')';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(2, ''6'',''6'',''19-APR-22'',''Highly recommend this place to budding entrepreneurs and people looking for a comfortable place to work.'',''1'')';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(3, ''9'',''7'',''18-APR-22'',''Using it, loved it. Perfect place for entrepreneurs'',''1'')';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(4, ''22'',''16'',''18-APR-22'',''Co- Working space. Great environment. Great place for team members'',''1'')';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(5, ''20'',''12'',''21-APR-22'',''Wifi network is not good to work with'',''0'')';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(6, ''15'',''19'',''18-APR-22'',''Very noisy due to construction on the roadside'',''0'')';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(7, ''21'',''17'',''18-APR-22'',''overall positive experience'',''1'')';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(8, ''13'',''3'',''22-APR-22'',''Take your own coffe to work'',''0'')';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(9, ''3'',''2'',''18-APR-22'',''overall positive experience'',''1'')';
        execute immediate 'INSERT INTO RENTAL_FEEDBACK(FEEDBACK_ID,B_ID,C_ID,FEEDBACK_DATE,FEEDBACK_REVIEW,FEEDBACK_RATING) VALUES(10, ''14'',''14'',''18-APR-22'',''Ambience is not productive'',''0'')';
        
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
        
    end;
END CREATE_ALL_TABLES;