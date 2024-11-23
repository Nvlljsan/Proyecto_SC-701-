CREATE DATABASE NeonFitnessDB;
USE NeonFitnessDB;

----------------------------- Roles -----------------------------
CREATE TABLE Roles (
    RolID INT PRIMARY KEY,
    NombreRol NVARCHAR(50) NOT NULL
);

----------------------------- Usuarios -----------------------------
CREATE TABLE Usuarios (
    UsuarioID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL,
    Apellido NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Contrasena NVARCHAR(100) NOT NULL,
    Telefono NVARCHAR(20),
    Direccion NVARCHAR(255),
    FechaRegistro DATE NOT NULL,
    RolID INT,
    FOREIGN KEY (RolID) REFERENCES Roles(RolID)
);

----------------------------- Clientes -----------------------------
CREATE TABLE Clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT,
    MembresiaActiva BIT NOT NULL,
    FechaInicioMembresia DATE,
    FechaFinMembresia DATE,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

----------------------------- Empleados -----------------------------
CREATE TABLE Empleados (
    EmpleadoID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT,
    Puesto NVARCHAR(50) NOT NULL,
    FechaContratacion DATE NOT NULL,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

----------------------------- Instructores -----------------------------
CREATE TABLE Instructores (
    InstructorID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT,
    Especialidad NVARCHAR(100),
    ExperienciaAnios INT,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

----------------------------- Productos -----------------------------
CREATE TABLE Productos (
    ProductoID INT IDENTITY(1,1) PRIMARY KEY,
    NombreProducto NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255),
    Precio DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL
);

----------------------------- Ventas -----------------------------
CREATE TABLE Ventas (
    VentaID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT,
    ProductoID INT,
    Cantidad INT NOT NULL,
    FechaVenta DATE NOT NULL,
    Total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);

----------------------------- Pagos -----------------------------
CREATE TABLE Pagos (
    PagoID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT,
    Monto DECIMAL(10, 2) NOT NULL,
    FechaPago DATE NOT NULL,
    MetodoPago NVARCHAR(50),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

----------------------------- Maquinas -----------------------------
CREATE TABLE Maquinas (
    MaquinaID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255),
    Ubicacion NVARCHAR(100),
    Estado BIT NOT NULL
);

----------------------------- Mantenimiento -----------------------------
CREATE TABLE MantenimientoMaquinas (
    MantenimientoID INT IDENTITY(1,1) PRIMARY KEY,
    EmpleadoID INT,
    MaquinaID INT,
    FechaMantenimiento DATE NOT NULL,
    Descripcion NVARCHAR(255),
    FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID),
    FOREIGN KEY (MaquinaID) REFERENCES Maquinas(MaquinaID)
);

----------------------------- Reservas -----------------------------
CREATE TABLE Reservas (
    ReservaID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT,
    FechaReserva DATE NOT NULL,
    HoraInicio TIME NOT NULL,
    HoraFin TIME NOT NULL,
    Estado BIT NOT NULL,
    MaquinaID INT,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (MaquinaID) REFERENCES Maquinas(MaquinaID)
);

----------------------------- ALTERS -----------------------------



----------------------------- INSERTS -----------------------------

----------------------------- Roles -----------------------------
INSERT INTO Roles (RolID, NombreRol) VALUES (1, 'Administrador');
INSERT INTO Roles (RolID, NombreRol) VALUES (2, 'Instructor');
INSERT INTO Roles (RolID, NombreRol) VALUES (3, 'Cliente');
INSERT INTO Roles (RolID, NombreRol) VALUES (4, 'Empleado');

----------------------------- SELECTS -----------------------------
SELECT 'Roles', COUNT(*)
FROM Roles
UNION ALL
SELECT 'Usuarios', COUNT(*)
FROM Usuarios
UNION ALL
SELECT 'Clientes', COUNT(*)
FROM Clientes
UNION ALL
SELECT 'Empleados', COUNT(*)
FROM Empleados
UNION ALL
SELECT 'Instructores', COUNT(*)
FROM Instructores
UNION ALL
SELECT 'Productos', COUNT(*)
FROM Productos
UNION ALL
SELECT 'Ventas', COUNT(*)
FROM Ventas
UNION ALL
SELECT 'Pagos', COUNT(*)
FROM Pagos
UNION ALL
SELECT 'Maquinas', COUNT(*)
FROM Maquinas
UNION ALL
SELECT 'MantenimientoMaquinas', COUNT(*)
FROM MantenimientoMaquinas
UNION ALL
SELECT 'Reservas', COUNT(*)
FROM Reservas;


-----------------------------Stored Procedures ----------------------------
-----------------------------Clientes----------------------------
Create PROCEDURE dbo.ActualizarCliente
@ClienteID int,        
@FechaInicioMembresia datetime,
@FechaFinMembresia datetime,
@MembresiaActiva bit        
          
AS
BEGIN

UPDate dbo.Clientes
set FechaInicioMembresia =@FechaInicioMembresia,
    FechaFinMembresia = @FechaFinMembresia,	
	MembresiaActiva = 	@MembresiaActiva
	where ClienteID = @ClienteID
END


-- Procedimiento para Inactivar cliente
CREATE PROCEDURE dbo.ClienteD
    @ClienteID int
AS
BEGIN
    UPDATE dbo.Clientes
    SET MembresiaActiva = 0
    WHERE ClienteID = @ClienteID
END


CREATE PROCEDURE dbo.ClientesR
    
AS
BEGIN
    SELECT ClienteID,C.UsuarioID,U.Nombre,MembresiaActiva,FechaInicioMembresia,FechaFinMembresia
	    FROM dbo.Clientes C
	inner join dbo.Usuarios U on C.UsuarioID = U.UsuarioID
  
END;

Create PROCEDURE dbo.ConsultarCliente
    @ClienteID INT
AS
BEGIN
     SELECT ClienteID,C.UsuarioID,U.Nombre,MembresiaActiva,FechaInicioMembresia,FechaFinMembresia
	    FROM dbo.Clientes C
	inner join dbo.Usuarios U on C.UsuarioID = U.UsuarioID

    WHERE ClienteID = @ClienteID;
END;

-----------------------------Maquinas ----------------------------
CREATE procedure dbo.MaquinasC
@Nombre	varchar(100),
@Descripcion	text,
@Ubicacion	varchar(100)

AS
BEGIN
INSERT INTO Maquinas(
           Nombre
           ,Descripcion
           ,Ubicacion
           ,Estado)
     VALUES
          ( @Nombre
           ,@Descripcion
           ,@Ubicacion
           ,1);
		   END;

create PROCEDURE dbo.MaquinasR 
    
AS
BEGIN
    SELECT[MaquinaID]
      ,[Nombre]
      ,[Descripcion]
      ,[Ubicacion]
      ,[Estado]
  FROM [NeonFitnessDB].[dbo].[Maquinas]
    
END;

CREATE PROCEDURE [dbo].[MaquinasU]
		@MaquinaID int,         
        @Nombre NVARCHAR(100) ,
		@Descripcion NVARCHAR(255),
    	@Ubicacion NVARCHAR(100),
		@Estado BIT      
          
AS
BEGIN

UPDate dbo.Maquinas
set		Nombre =@Nombre,
		Descripcion = @Descripcion,	
		Ubicacion = @Ubicacion,
		Estado = @Estado         

	where MaquinaID =@MaquinaID

END












