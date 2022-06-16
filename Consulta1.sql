/*
10.- El 21nombre, apellido y dirección de los empleados con sus horas que trabajan entre 10 y
30 horas en total.
 */
 select nombrep, apellido, direccion from empleado join trabaja_en te on empleado.nss = te.nsse where horas between 10 and 30;
 /*
El nombre, apellido y dirección de los empleados, el nombre y edad de los
dependientes que empiecen con A.
  */
select nombrep, apellido, direccion from empleado join dependiente d on empleado.nss = d.nsse where nombre_dependiente like 'A%';
/*
 El nombre, apellido y dirección de los empleados que ingresaron después del 01 de
enero del 1985.
 */
 Select nombrep, apellido, direccion from empleado join departamento d on empleado.nd = d.numerod where fechainicgte between '01-01-1985' and '01-01-2021';
/*
 Los proyectos que estén en Higueras, el nombre, apellido y dirección de los empleados
de los proyectos.
 */
select empleado.nombrep, empleado.apellido, empleado.direccion from empleado
    inner join proyecto p on empleado.nombrep = p.nombrep where lugarp GROUP BY '%HIGUERAS%';
select empleado.nombrep, empleado.apellido, empleado.direccion from empleado
    inner join proyecto p on empleado.nombrep = p.nombrep where p.nombrep like '%PROYECTO%';