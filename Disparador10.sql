create or replace function control_empleados() returns trigger as
    $$
    BEGIN
        if (select nsssuper from empleado where nsssuper = nss) <= 5 then
            raise exception 'supervisor';
            else
            raise exception 'exede el maximo de subordinados';
        end if;
    end;
$$
language plpgsql;
create trigger maximo_empleados before insert or update
    on empleado for each row
    execute procedure control_empleados()

CREATE TABLE HISTORICO_EMPLEADO(
    NOMBREP   VARCHAR(30)                     NOT NULL,
    INIC      NCHAR(1)                        NOT NULL,
    APELLIDO  VARCHAR(30)                     NOT NULL,
    NSS       INTEGER PRIMARY KEY NOT NULL,
    FECHANAC  DATE                            NOT NULL,
    DIRECCION VARCHAR(100)                    NOT NULL,
    SEXO      CHAR(1)                         NOT NULL
        CONSTRAINT CKEmpleado_SEXO check (sexo = 'F' or sexo = 'M'),
    SALARIO   DECIMAL(8, 2)                   NOT NULL
        CONSTRAINT CKEmpleado_SALARIO_POSITIVO check (salario >= 0.0),
    NSSSUPER  INTEGER                         NULL,
    ND        INTEGER                         NOT NULL
);

create or replace function guardar_historicos() returns trigger as
    $$
    BEGIN
        if (tg_op = 'DELETE') then
        update empleado set nss = nss + old.nss
        where nss = old.nss;
            --insert into historico_empleado values (old);
        return old;
        end if ;
    end;
$$
language plpgsql;

create trigger registro_eliminado after delete
    on empleado for each row
    execute procedure guardar_historicos()

delete from empleado where nss= 999887777;

