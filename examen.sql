create table PRODUCTO (
    ID int not null primary key,
    NOMBRE varchar(20) NOT NULL,
    PRECIO_VENTA money NOT NULL,
    EXISTENCIA int NOT NULL,
    MINIMO_STOCK int not null
);

create table CLIENTE(
    ID int not null primary key,
    NOMBRE varchar(20) not null,
    DIRECCION varchar(20)
);

CREATE TABLE FACTURA(
    ID int not null primary key ,
    ID_CLIENTE int not null ,
    FECHA DATE NOT NULL ,
    DESCUENTO money NOT NULL ,
    IVA int not null,
    TOTAL money NOT NULL
);

create table DETALLE_FACTURA(
    ID INT NOT NULL PRIMARY KEY,
    ID_FACTURA int not null,
    ID_PRODUCTO int not null,
    CANTIDAD int not null
);

alter table FACTURA
add constraint fk_1
foreign key (ID_CLIENTE)
references CLIENTE (ID);

alter table DETALLE_FACTURA
add constraint fk_idfactura
foreign key (ID_FACTURA)
references FACTURA (ID);

alter table DETALLE_FACTURA
add constraint fk_idproducto
foreign key (ID_PRODUCTO)
references PRODUCTO (ID);

INSERT INTO PRODUCTO VALUES (1, 'MAYONESA', 10.50, 200, 100);
INSERT INTO PRODUCTO VALUES (2, 'BOTELLA DE AGUA', 1.00, 500, 500);
INSERT INTO PRODUCTO VALUES (3, 'COCA COLA', 1.25, 400, 400);

INSERT INTO CLIENTE VALUES (1, 'MARTHA PINEDA', 'TOLITA');
INSERT INTO CLIENTE VALUES (2, 'SANDRA SERRANO', 'CODESA');

INSERT INTO FACTURA VALUES (1, 1, '05/11/2014', 0, 12, 100);
INSERT INTO FACTURA VALUES (2, 2, '05/11/2014', 0, 24, 200);
INSERT INTO FACTURA VALUES (3, 2, '05/11/2014', 0, 48, 300);

INSERT INTO DETALLE_FACTURA VALUES (1, 1, 1, 10);
INSERT INTO DETALLE_FACTURA VALUES (2, 2, 3, 5);
INSERT INTO DETALLE_FACTURA VALUES (3, 2, 1, 7);

create or replace function stock_venta() returns trigger
as
    $$BEGIN
        if cantidad < old.existencia then
            update PRODUCTO set EXISTENCIA = EXISTENCIA - (new.cantidad - old.existencia)
            where ID = new.ID;
            return new;
            if (select MINIMO_STOCK from PRODUCTO where MINIMO_STOCK < PRODUCTO.EXISTENCIA) then
                raise exception 'se esta agostando el producto';
            end if;
        else
            raise exception 'No hay el suficiente producto';
        end if;
        end;
    $$
language plpgsql;

create trigger stock_ventra before update
    on PRODUCTO for each row
    execute procedure stock_venta()

