create or replace function ver_cantidad() returns trigger as
    $$
    declare
        existencia int;
        pedido int;
    BEGIN
        select unidadesenexistencia into existencia from producto where existencia = idproducto;
        select cantidad into pedido from detallepedido where pedido = iddetalle;
        if existencia  <= pedido then
            return new;
            else
                raise exception 'existe la cantidad en existencia';
        end if;
    end;
$$
language plpgsql;

create trigger ver_cantidad before update
    on producto for each row
    execute procedure ver_cantidad();

--Cada vez que se realice un pedido aplique un descuento del 10%.
create or replace function realizar_pedido() returns trigger as
    $$
    declare
        pedido int;
        descuento money;
    BEGIN
        if (tg_op = 'INSERT') THEN
            pedido:=(select unidadesenpedido from producto where unidadesenpedido = producto.idproducto + 1);
            update producto set unidadesenpedido = pedido where unidadesenpedido = producto.idproducto;
            descuento:=(select cargo from pedido where descuento = idproducto * 0.10);
            return descuento;
            else
            raise exception 'no existe la cantidad en existencia';
        end if;
        end;
    $$
language plpgsql;

create trigger realizar_pedido before insert
    on detallepedido for each row
    execute procedure realizar_pedido();
insert into pedido values (100,15,6,'2022/06/16','2022/06/20','2022/06/17',1,30,'ESMERALDAS','5 DE AGOSTO');
insert into detallepedido values (102,2855,77,13,10,10);

