create schema wheels_quick;

set schema 'wheels_quick';

--drop schema wheels_quick CASCADE;

create domain standard_length varchar(20);
create domain phone_length char(11);
create domain zip_length int;

create table Users(
    fname standard_length not null,
    lname standard_length not null,
    phoneNumber phone_length not null,
    username standard_length primary key not null,
    password standard_length not null
);


create table Employee(
     employeeID varchar(20) not null primary key
) inherits (Users);

create table Client(
    clientID serial not null,
    primary key (username)
) inherits (Users);

create table CarType(
    type varchar(50) not null primary key
);

create table Place(
    city varchar(50) not null,
    address varchar(50) not null primary key,
    zipCode zip_length not null
);

create table Car(
    Brand varchar(15),
    Model varchar(25),
    type varchar(50),
    isRented boolean default false,
    licencePlate varchar(12) not null primary key,
    foreign key (type) references CarType(type)
);

create table Rent(
    RentID serial not null,
    username standard_length not null,
    licencePlate varchar(12),
    picking_place varchar(50),
    returning_place varchar(50),
    foreign key (username) references Client (username),
    foreign key (licencePlate) references Car(licencePlate),
    foreign key (picking_place) references Place(address),
    foreign key (returning_place) references Place(address),
    primary key (username, licencePlate)
);

create or replace function new_client() returns trigger as
    $$
    declare
        clients_found integer;
    begin
        select count(*) into clients_found from Client where username = NEW.username;
        if clients_found > 0 then
            raise exception 'Username already exists';
        end if;
        return new;
    end;
    $$ language plpgsql;

-- prevent same username
create trigger new_user before insert on Client for each row execute procedure new_client();

insert into CarType values('Small'),
                           ('Hatchback'),
                           ('SUV'),
                           ('Electric');

insert into Place VALUES('Horsens', 'Kamtjatka 7', 8700),
                         ('Horsens', 'Ribersgade 1', 8700),
                         ('Aarhus', 'Brammersgade 11', 8200),
                         ('Aarhus', 'Montanagade 5', 8210),
                         ('Copenhagen', 'Letlandsgade 2', 1067),
                         ('Copenhagen', 'Alsgade 4', 1073),
                         ('Copenhagen', 'Steenbergsvej 8', 1054);

insert into Employee values('John', 'Doe', '+4512437812', 'johndoe', '1234', 'E1');