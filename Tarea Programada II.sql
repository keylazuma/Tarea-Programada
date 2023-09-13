--BASE DE DATOS
CREATE DATABASE [BASE] -- Se crea una base de datos que necesita otras definiciones
ON
(NAME= N'DATA', -- Se le asigna un nombre
	FILENAME= N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\BASE.mdf',
	SIZE= 10,
	MAXSIZE= 20, 
	FILEGROWTH= 2)
LOG ON  
(NAME = N'BASE1_log',  
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\BASE.ldf',  
    SIZE = 5,  
    MAXSIZE = 20,  
    FILEGROWTH = 2);   
GO
 

 -- TABLAS
 USE BASE;
Go

DROP TABLE factura_rel
DROP TABLE proveedores_rel
DROP TABLE Factura
DROP TABLE Proveedor
DROP TABLE Producto
DROP TABLE Subcategoria
DROP TABLE Cliente
DROP TABLE Categoria
DROP TABLE Territorio

--TABLA TERRITORIO
CREATE TABLE Territorio(
ID_territorio INT NOT NULL  CONSTRAINT ID_terr PRIMARY KEY,
Provincia CHAR(10) NOT NULL,
Canton CHAR(25) NOT NULL,
Distrito CHAR(25) NOT NULL)

--TABLA CATEGORÍA
CREATE TABLE Categoria(
ID_categoria INT NOT NULL  CONSTRAINT ID_categ PRIMARY KEY,
Nombre CHAR(35) NOT NULL,)


-- TABLA CLIENTE
CREATE TABLE Cliente(
Cedula BIGINT NOT NULL CONSTRAINT ced_cliente PRIMARY KEY CHECK (LEN(cedula)<11 and LEN(Cedula)>8),
Correo CHAR(100) NOT NULL,
Nombre CHAR(100) NOT NULL, 
Tipo_cedula CHAR(10) NOT NULL, 
Direccion CHAR(150) NOT NULL,
NumTelefono INT NOT NULL CHECK (LEN(NumTelefono)=8))-- Los números en CR solo tienen 8 digitos

-- TABLA SUBCATEGORÍA
CREATE TABLE Subcategoria(
ID_subcategoria INT NOT NULL  CONSTRAINT ID_subcat PRIMARY KEY,
Nombre CHAR(65) NOT NULL,
ID_categoria INT NOT NULL, CONSTRAINT ID2_categoria FOREIGN KEY (ID_categoria) REFERENCES Categoria(ID_categoria))

--TABLA PRODUCTO
CREATE TABLE Producto(
    Codigo_prod INT NOT NULL IDENTITY,
    Nombre CHAR(30) NOT NULL, 
     Tamaño INT,
	 Color CHAR(10) NOT NULL,
	 Precio INT NOT NULL,
    ID_univ CHAR(10) NOT NULL,
    ID_producto AS CONCAT(Codigo_prod, ID_univ) PERSISTED,
    ID_subcategoria INT NOT NULL,
    CONSTRAINT ID2_subcategoria FOREIGN KEY (ID_subcategoria) REFERENCES Subcategoria(ID_subcategoria))
ALTER TABLE Producto 
ADD CONSTRAINT ID_product PRIMARY KEY (ID_producto)


--TABLA PROVEEDOR
CREATE TABLE Proveedor(
Cedula BIGINT NOT NULL CONSTRAINT ced_prov PRIMARY KEY CHECK (LEN(cedula) <11 and LEN(Cedula)>8),
Nombre CHAR(70)NOT NULL,
Correo CHAR(60) NOT NULL,
Numero_tel INT NOT NULL CHECK (LEN(Numero_tel)=8),
Tipo_cedula CHAR(8) NOT NULL, 
ID_territorio INT NOT NULL, 
CONSTRAINT ID2_Territorio FOREIGN KEY (ID_Territorio) REFERENCES Territorio(ID_territorio))

--TABLA FACTURA
CREATE TABLE Factura(
numero_fact INT NOT NULL IDENTITY CONSTRAINT n_f PRIMARY KEY,
producto CHAR(100) NOT NULL,
precio INT NOT NULL,
impuestos DECIMAL(10,2) CHECK(impuestos>=0 and impuestos <14),
descuento DECIMAL(10,2) CHECK(descuento>=0 and descuento <101),
fecha DATE,
tipo_pago CHAR(8),
codigo_int INT NOT NULL,
nombre_proveedor CHAR(60),
unidades_comp INT NOT NULL,
Cedula BIGINT NOT NULL, CONSTRAINT ID2_cedula FOREIGN KEY (Cedula) REFERENCES cliente(Cedula))

--TABLAS DE RELACIONES N:M
CREATE TABLE factura_rel(
ID INT NOT NULL IDENTITY CONSTRAINT ID PRIMARY KEY, 
unidades_comp INT NOT NULL,
precio_final INT,
numero_fact INT NOT NULL, CONSTRAINT ID2_factura FOREIGN KEY (numero_fact) REFERENCES Factura(numero_fact),
ID_producto VARCHAR(22) NOT NULL, CONSTRAINT ID2_producto2 FOREIGN KEY (ID_producto) REFERENCES Producto(ID_producto))

CREATE TABLE proveedores_rel(
Proveedor INT NOT NULL IDENTITY(1000,100) PRIMARY KEY,
unidades INT NOT NULL,
ID_producto VARCHAR(22) NOT NULL, CONSTRAINT ID2_producto3 FOREIGN KEY (ID_producto) REFERENCES Producto(ID_producto),
Cedula BIGINT NOT NULL, CONSTRAINT ID2_cedula2 FOREIGN KEY (Cedula) REFERENCES Proveedor(Cedula))


--Insertar datos 

--TABLA TERRITORIO
INSERT INTO Territorio(ID_territorio,Provincia,Canton,Distrito)
values (10203,'San José','Escazu','San Rafael'),
(11503,'San José','Montes de Oca','Mercedes'),
(11301,'San José','Tibas','San Juan'),
(51002,'Guanacaste','La Cruz','Santa Cecilia'),
(51105,'Guanacaste','Hojancha','Matambú'),
(30502,'Cartago','Turrialba','La Suiza'),
(60504,'Puntarenas','Osa','Bahía Ballena'),
(50903,'Guanacaste','Nandayure','Zapotal'),
(70204,'Limon','Pococí','Roxana'),
(70502,'Limon','Matina',' Batán'),
(40305,'Heredia','Santo Domingo','Santo Tomás'),
(30702,'Cartago','Oreamuno',' Cot'),
(21204,'Alajuela','Sarchí','San Pedro'),
(30102,'Cartago','Cartago',' Occidental'),
(21401,'Alajuela','Los Chiles','Los Chiles')

SELECT *
FROM dbo.Territorio

--TABLA CATEGORÍA
-- Tabla Categoria
INSERT INTO Categoria(ID_categoria,Nombre)
values (1,'Productos Dermatológicos'),
(2,'Salud Femenina'),
(3,'Hematología y Coagulación'),
(4,'Medicamentos Cardiovasculares'),
(5,'Medicamentos Respiratorios'),
(6,'Medicamentos Gastrointestinales'),
(7,'Productos Oftalmológicos'),
(8,'Medicamentos Neurológicos'),
(9,'Salud Mental'),
(10,' Salud Urológica'),
(11,'Salud Musculoesquelética'),
(12,'Salud Renal y Urinaria')

SELECT *
FROM dbo.Categoria


-- TABLA CLIENTE
INSERT INTO Cliente(Cedula,Tipo_cedula,NumTelefono,Nombre,Correo,Direccion)
VALUES(401250648,'Fisica',60894567,'Juan Rodríguez','juanrod02@gmail.com','200 metros este de la iglesia de San Ramon, Alajuela'),
(3101987651,'Juridica',74823015,'Residencias de Cuidados a Largo Plazo S.A','contacto@residencias-cuidados-largo-plazo.com','700 metros noreste del Sanatorio'),
(405670923,'Fisica',82567894,'Carlos Martínez','cmartimez2571@hotmail.com','300 metros al norte del estadio ecologico, san pedro'),
(3101765983,'Juridica',68574920,'Consultoría en Salud y Farmacología S.A','consultoria@salud-y-farmacologia.com','1km al norte del pricemart zapote'),
(107890996,'Fisica',87120963,'Alejandro López','alelopezz001@gmail.com','350 metros este del Parque de la Natividad, Alajuela'),
(3101286798,'Juridica',72098654,'Red de Farmacias de Confianza S.A','servicio.clientes@red-farmacias-confianza.com','400 metros sur de la Playa Conchal, Guanacaste'),
(607890234,'Fisica',78540326,'Marta Ramírez','martitars@hotmail.com','350 metros sur del Hospital Max Peralta, Cartago'),
(3101954367,'Juridica',83654721,'Centro de Atención Geriátrica Avanzada S.A','contacto@atencion-geriatrica-avanzada.com','500 metros sur del Aeropuerto Internacional Juan Santamaría'),
(507890123,'Fisica',72659814,'Sandra Ortiz','sandraort0@yahoo.com','300 metros sur del Museo de Oro Precolombino'),
(3101659380,'Juridica',69321847,'Farmacovigilancia y Seguridad del Paciente Ltda','seguridad@farmacovigilancia-seguridad-paciente.com','280 metros este del Parque Vargas, Limón'),
(207890567,'Fisica',86934275,'Ana Fernández','aluciafer@hotmail.com','350 metros oeste del Parque Recreativo de Heredia'),
(3101874107,'Juridica',79856432,'Clínicas Dentales Especializadas S.A','citas@dental-especializada.com','280 metros norte del Mercado Central'),
(405670123,'Fisica',84207516,'Sergio Herrera','herrerasergio2345@gmail.com','180 metros sur del Centro Comercial Plaza Real, Alajuela')

SELECT * 
FROM dbo.Cliente

-- TABLA SUBCATEGORÍA
INSERT INTO Subcategoria(ID_subcategoria,Nombre,ID_categoria)
VALUES(010,'Cremas Antiarrugas',1),
(011,'Anticonceptivos',2),
(012,'Anticoagulantes',3),
(013,'Antihipertensivos',4),
(014,'Inhaladores para el Asma',5),
(015,'Antiácidos',6),
(016,'Medicamentos para el Glaucoma',7),
(017,'Antiepilépticos',8),
(018,'Antipsicóticos',9),
(019,'Medicamentos para la Disfunción Eréctil',10),
(020,'Analgésicos Musculares',11),
(021,'Medicamentos Diuréticos',12),
(022,'Ansiolíticos',9),
(023,'Tratamientos para la Hemofilia',3),
(024,'Antihistamínicos para la Alergia Respiratoria',5),
(025,'Gotas para los Ojos',7),
(026,'Protectores Solares',1),
(027,'Productos para la Menopausia',2),
(028,'Estabilizadores del Estado de Ánimo',9),
(029,'Estatinas',4),
(030,'Antib. Infecciones del Tracto Urinario',10),
(031,'Tratamientos para la Insuficiencia Renal',12),
(032,'Medicamentos para el Parkinson',8),
(033,'Suplementos para la Salud de los Huesos',11)

SELECT*
FROM dbo.Subcategoria

--TABLA PRODUCTO
INSERT INTO Producto(Nombre,Tamaño,Color,Precio,ID_univ,ID_subcategoria)
VALUES(' Crema antiarrugas Neutrogena',200,'Rosado',25000,2000,010),
('Dispositivo intrauterino (DIU)',10,'Blanco',30000,3000,011),
('Factor VIII',250,'Rojo',15000,4000,023),
(' Losartán',150,'Gris',56000,5000,013),
('Fluticasona',30,'Azul',10000,6000,014),
('Latanoprost',25,'Cafe',5600,7000,016),
('Carbamazepina',60,'Amarillo',35000,8000,017),
('Rasagilina',50,'Blanco',24900,1000,032)

SELECT*
FROM dbo.Producto

--TABLA PROVEEDOR

INSERT INTO Proveedor(Cedula,Tipo_cedula,Nombre,Correo,Numero_Tel,ID_territorio)
VALUES (707030703,'Fisica','Ezequiel Dávalos','ezeqdavalos11@gmail.com.com',67890123,11503),
(702340567,'Juridica','Suministros Médicos y Farmacéuticos S.A','elbicho@siu.com',71234567,11301),
(603450678,'Juridica','Innovación en Envases Farmacéuticos S.A','pokemon@nintendo.com',82345678,51002),
(107890456,'Fisica','Octavio Sarmiento','octaviooooo@gmail.com.com',76456789,70502),
(608901234,'Juridica','Distribuidora Farmacéutica Global Ltda','keylor@navas.com',85768901,21204),
(509890123,'Juridica','Servicios de Investigación Clínica Avanzada Ltda','jackson5@musica.com',68567890,21401),
(300910234,'Fisica','Plácido Fuentes','placifuentes@yahoo.com',76890123,10203),
(706900234,'Fisica','Jenaro Salgado','saljenaro@hotmail.com.com',87654321,30502)

SELECT*
FROM dbo.Proveedor

--TABLA FACTURA
INSERT INTO Factura (fecha,codigo_int,Cedula,producto,unidades_comp, impuestos, descuento,tipo_pago,precio,nombre_proveedor)
VALUES('2020-09-21',01010101,401250648,'Crema antiarrugas Neutrogena',2,13,0, 'credito', 25000, 'Juan Rodríguez'),
  ('2023-08-12',01010101,107890996,'Factor VIII',6,13,4, 'efectivo', 15000, 'Alejandro Lopez'),
  ('2022-07-01',01010101,3101954367,'Carbamazepina',4,13,8, 'credito', 35000, 'Centro de atencion geriatrica avanzada S.A'),
  ('2022-06-15',01010101,507890123,'Losartán',12,0,0, 'efectivo', 56000, 'Sandra Ortiz'),
  ('2023-01-19',01010101,207890567,'Crema antiarrugas Neutrogena',1,13,25, 'efectivo', 25000, 'Ana Fernandez'),
  ('2023-04-30',01010101,3101659380,'Crema antiarrugas Neutrogena',1,1,75, 'credito', 25000, 'Farmacovigilancia y Seguridad del paciente Ltda'),
  ('2022-09-04',01010101,405670123,'Losartán',5,1,0, 'efectivo', 56000, 'Sergio Herrera')

SELECT * 
FROM dbo.Factura

--TABLAS DE RELACIONES N:M
--TABLA FACTURA RELACIONAL
INSERT INTO factura_rel (unidades_comp, numero_fact, ID_producto)
VALUES (2, 6, 147000),
 (5, 7,23000),
 (1, 3, 45000),
 (22, 4, 81000),
 (2, 2,78000),
 (1,4, 92000),
 (5, 7, 147000)


--TABLA PROVEEDOR RELACIONAL
INSERT INTO proveedores_rel(unidades,ID_producto,Cedula)
VALUES (200, 147000, 707030703),
 (7, 45000, 702340567),
 (24, 23000, 608901234),
 (33, 81000, 509890123),
 (100, 78000, 300910234),
 (87,147000, 107890456),
 (8, 92000, 603450678),
 (300, 158000, 702340567)

SELECT*
FROM dbo.proveedores_rel

-- Actualiza el precio_final en la tabla factura_rel
UPDATE factura_rel
SET factura_rel.precio_final = factura_rel.unidades_comp * Producto.Precio
FROM factura_rel
INNER JOIN Producto ON factura_rel.ID_producto = Producto.ID_producto;

-- Actualiza el Precio en la tabla Factura
UPDATE Factura
SET Precio = (
    SELECT SUM(factura_rel.precio_final)
    FROM factura_rel
    WHERE factura_rel.numero_fact = Factura.numero_fact
)
WHERE EXISTS (
    SELECT 1
    FROM factura_rel
    WHERE factura_rel.numero_fact = Factura.numero_fact
);


-- Consultas
SELECT
    pr.Cedula AS CedulaProveedor,
    p.Nombre AS NombreProveedor,
    SUM(pr.unidades) AS TotalUnidadesCompradas
FROM proveedores_rel pr
INNER JOIN Proveedor p ON pr.Cedula = p.Cedula
GROUP BY pr.Cedula, p.Nombre
ORDER BY TotalUnidadesCompradas DESC;


SELECT
    DATEPART(YEAR, fecha) AS Año,
    DATEPART(MONTH, fecha) AS Mes,
    SUM(Precio) AS TotalVentasPorMes
FROM Factura
GROUP BY DATEPART(YEAR, fecha), DATEPART(MONTH, fecha)
ORDER BY Año, Mes;

SELECT COUNT(DISTINCT ID_producto) AS CantidadProductosDiferentes
FROM Producto;

SELECT
    c.Cedula AS CedulaCliente,
    c.Nombre AS NombreCliente,
    SUM(f.unidades_comp) AS TotalUnidadesCompradas
FROM Factura f
INNER JOIN Cliente c ON f.Cedula = c.Cedula
GROUP BY c.Cedula, c.Nombre
ORDER BY TotalUnidadesCompradas DESC;

SELECT
    c.Nombre AS CategoriaProducto,
    SUM(f.unidades_comp) AS TotalUnidadesVendidas
FROM Factura f
INNER JOIN Producto p ON f.producto = p.Nombre
INNER JOIN Subcategoria s ON p.ID_subcategoria = s.ID_subcategoria
INNER JOIN Categoria c ON s.ID_categoria = c.ID_categoria
GROUP BY c.Nombre
ORDER BY TotalUnidadesVendidas ASC;