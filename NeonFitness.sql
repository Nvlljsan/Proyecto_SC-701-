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
ALTER TABLE Reservas
ADD CONSTRAINT DF_Reservas_Estado DEFAULT 1 FOR Estado;



----------------------------- INSERTS -----------------------------

----------------------------- Roles -----------------------------
INSERT INTO Roles (RolID, NombreRol) VALUES (1, 'Administrador');
INSERT INTO Roles (RolID, NombreRol) VALUES (2, 'Instructor');
INSERT INTO Roles (RolID, NombreRol) VALUES (3, 'Cliente');
INSERT INTO Roles (RolID, NombreRol) VALUES (4, 'Empleado');





----------------------------- STORED PROCEDURES ----------------------------
----------------------------- Clientes ----------------------------
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
END;
GO

CREATE PROCEDURE dbo.ClienteD
    @ClienteID int
AS
BEGIN
    UPDATE dbo.Clientes
    SET MembresiaActiva = 0
    WHERE ClienteID = @ClienteID
END;
GO

CREATE PROCEDURE dbo.ClientesR  
AS
BEGIN
    SELECT ClienteID,C.UsuarioID,U.Nombre,MembresiaActiva,FechaInicioMembresia,FechaFinMembresia
	    FROM dbo.Clientes C
	inner join dbo.Usuarios U on C.UsuarioID = U.UsuarioID
END;
GO

Create PROCEDURE dbo.ConsultarCliente
    @ClienteID INT
AS
BEGIN
     SELECT ClienteID,C.UsuarioID,U.Nombre,MembresiaActiva,FechaInicioMembresia,FechaFinMembresia
	    FROM dbo.Clientes C
	inner join dbo.Usuarios U on C.UsuarioID = U.UsuarioID

    WHERE ClienteID = @ClienteID;
END;
GO
	
----------------------------- Maquinas ----------------------------
CREATE procedure dbo.MaquinasC
@Nombre	varchar(100),
@Descripcion	text,
@Ubicacion	varchar(100)
AS
BEGIN
INSERT INTO Maquinas(Nombre, Descripcion, Ubicacion, Estado)
     VALUES(@Nombre, @Descripcion, @Ubicacion, 1);
END;
GO
	
CREATE PROCEDURE dbo.MaquinasR  
AS
BEGIN
    SELECT[MaquinaID],[Nombre],[Descripcion],[Ubicacion],[Estado]
  FROM [NeonFitnessDB].[dbo].[Maquinas]
END;
GO
	
CREATE PROCEDURE [dbo].[MaquinasU]
	@MaquinaID int,         
	@Nombre NVARCHAR(100),
	@Descripcion NVARCHAR(255),
    	@Ubicacion NVARCHAR(100),
	@Estado BIT               
AS
BEGIN
UPDATE dbo.Maquinas
SET	Nombre =@Nombre,
	Descripcion = @Descripcion,	
	Ubicacion = @Ubicacion,
	Estado = @Estado        
WHERE MaquinaID =@MaquinaID
END;
GO

----------------------------- Empleados e Instructores ----------------------------
CREATE PROCEDURE AgregarEmpleado
    @UsuarioID INT,
    @Puesto NVARCHAR(50),
    @FechaContratacion DATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Empleados WHERE UsuarioID = @UsuarioID)
    BEGIN
        RAISERROR ('El UsuarioID ya está asignado como empleado.', 16, 1);
        RETURN;
    END
    INSERT INTO Empleados (UsuarioID, Puesto, FechaContratacion)
    VALUES (@UsuarioID, @Puesto, @FechaContratacion);
    SELECT SCOPE_IDENTITY() AS NuevoEmpleadoID;
END;
GO
	
CREATE PROCEDURE AgregarInstructor
    @UsuarioID INT,
    @Especialidad NVARCHAR(100),
    @ExperienciaAnios INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Instructores WHERE UsuarioID = @UsuarioID)
    BEGIN
        RAISERROR ('El UsuarioID ya está asignado como instructor.', 16, 1);
        RETURN;
    END
    INSERT INTO Instructores (UsuarioID, Especialidad, ExperienciaAnios)
    VALUES (@UsuarioID, @Especialidad, @ExperienciaAnios);
    SELECT SCOPE_IDENTITY() AS NuevoInstructorID;
END;
GO

CREATE PROCEDURE ModificarEmpleado
    @EmpleadoID INT,
    @Puesto NVARCHAR(50),
    @FechaContratacion DATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Empleados
    SET 
        Puesto = @Puesto,
        FechaContratacion = @FechaContratacion
    WHERE 
        EmpleadoID = @EmpleadoID;
END;
GO

CREATE PROCEDURE ModificarInstructor
    @InstructorID INT,
    @Especialidad NVARCHAR(100),
    @ExperienciaAnios INT
AS
BEGIN
    UPDATE Instructores
    SET Especialidad = @Especialidad,
        ExperienciaAnios = @ExperienciaAnios
    WHERE InstructorID = @InstructorID;
END;
GO

CREATE PROCEDURE ObtenerEmpleadoPorID
    @EmpleadoID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT e.EmpleadoID, e.UsuarioID, e.Puesto, e.FechaContratacion,
           u.Nombre, u.Apellido, u.Email, u.Telefono
    FROM Empleados e
    INNER JOIN Usuarios u ON e.UsuarioID = u.UsuarioID
    WHERE e.EmpleadoID = @EmpleadoID;
END;
GO

CREATE PROCEDURE ObtenerEmpleados
AS
BEGIN
    SET NOCOUNT ON;

    SELECT e.EmpleadoID, e.UsuarioID, e.Puesto, e.FechaContratacion, 
           u.Nombre, u.Apellido, u.Email, u.Telefono
    FROM Empleados e
    INNER JOIN Usuarios u ON e.UsuarioID = u.UsuarioID;
END;
GO

CREATE PROCEDURE ObtenerInstructores
AS
BEGIN
    SELECT 
        i.InstructorID, 
        i.UsuarioID, 
        u.Nombre, 
        u.Apellido, 
        u.Email, 
        u.Telefono, 
        i.Especialidad, 
        i.ExperienciaAnios
    FROM Instructores i
    INNER JOIN Usuarios u ON i.UsuarioID = u.UsuarioID;
END;
GO

CREATE PROCEDURE ObtenerInstructorPorID
    @InstructorID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        i.InstructorID,
        i.UsuarioID,
        i.Especialidad,
        i.ExperienciaAnios,
        u.Nombre,
        u.Apellido,
        u.Email,
        u.Telefono
    FROM 
        Instructores i
    INNER JOIN 
        Usuarios u ON i.UsuarioID = u.UsuarioID
    WHERE 
        i.InstructorID = @InstructorID;
END;
GO

CREATE PROCEDURE ObtenerUsuariosParaEmpleados
AS
BEGIN
    SET NOCOUNT ON;

    SELECT UsuarioID, Nombre, Apellido 
    FROM Usuarios 
    WHERE RolID = 4;
END;
GO

CREATE PROCEDURE ObtenerUsuariosRol2
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        UsuarioID,
        Nombre,
        Apellido
    FROM 
        Usuarios
    WHERE 
        RolID = 2;
END;
GO

CREATE PROCEDURE sp_ActualizarEmpleado
    @EmpleadoID INT,
    @UsuarioID INT,
    @Puesto NVARCHAR(50),
    @FechaContratacion DATE
AS
BEGIN
    UPDATE Empleados
    SET 
        UsuarioID = @UsuarioID,
        Puesto = @Puesto,
        FechaContratacion = @FechaContratacion
    WHERE EmpleadoID = @EmpleadoID;
END;
GO

----------------------------- Usuarios ----------------------------
CREATE PROCEDURE [dbo].[UsuarioC] ---- CREATE ----
	@Nombre NVARCHAR(50),
	@Apellido NVARCHAR(50),
	@Email NVARCHAR(100),
    	@Contrasena NVARCHAR(100),
    	@Telefono NVARCHAR(20),
    	@Direccion NVARCHAR(255),
    	@FechaRegistro DATE,
    	@RolID INT
AS
BEGIN
	INSERT INTO Usuarios (Nombre, Apellido, Email, Contrasena, Telefono, Direccion, FechaRegistro, RolID)
    VALUES (@Nombre, @Apellido, @Email, @Contrasena, @Telefono, @Direccion, GETDATE(), @RolID);
END;
GO
	
CREATE PROCEDURE [dbo].[UsuarioR] ---- READ ---- 
    @UsuarioID INT
AS
BEGIN
    SELECT UsuarioID, Nombre, Apellido, Email, Contrasena, Telefono, Direccion, FechaRegistro, RolID
    FROM Usuarios
    WHERE UsuarioID = @UsuarioID;
END;
GO
	
CREATE PROCEDURE [dbo].[UsuarioU] ---- UPDATE ----
    @UsuarioID INT,
    @Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
    @Email NVARCHAR(100),
    @Contrasena NVARCHAR(100),
    @Telefono NVARCHAR(20),
    @Direccion NVARCHAR(255),
    @RolID INT
AS
BEGIN
    UPDATE Usuarios
    SET Nombre = @Nombre,
        Apellido = @Apellido,
        Email = @Email,
        Contrasena = @Contrasena,
        Telefono = @Telefono,
        Direccion = @Direccion,
        RolID = @RolID
    WHERE UsuarioID = @UsuarioID;
END;
GO
	
CREATE PROCEDURE [dbo].[UsuarioD] ---- DELETE ----
    @UsuarioID INT
AS
BEGIN
    DELETE FROM Usuarios
    WHERE UsuarioID = @UsuarioID;
END;
GO

CREATE PROCEDURE UsuariosLista
AS
BEGIN
    SELECT UsuarioID, Nombre, Apellido, Email, Telefono, Direccion, FechaRegistro, RolID
    FROM Usuarios;
END;
GO
-------------------------- SP LOGEO --------------------------
CREATE PROCEDURE [dbo].[Registro] ---- FUNCIONAL ----
	@Nombre NVARCHAR(50),
	@Apellido NVARCHAR(50),
	@Email NVARCHAR(100),
	@Contrasena NVARCHAR(100),
	@Telefono NVARCHAR(20),
	@Direccion NVARCHAR(255),
	@RolID INT
AS
BEGIN
	INSERT INTO Usuarios (Nombre, Apellido, Email, Contrasena, Telefono, Direccion, FechaRegistro, RolID)
    VALUES (@Nombre, @Apellido, @Email, @Contrasena, @Telefono, @Direccion, GETDATE(), @RolID);
END;

CREATE PROCEDURE [dbo].[InicioSesion] ---- SIN PROBAR ----
	@Email NVARCHAR(100),
    @Contrasena NVARCHAR(100)
AS
BEGIN
	SELECT UsuarioID, Nombre, Apellido, RolID
    FROM Usuarios
    WHERE Email = @Email AND Contrasena = @Contrasena;
END;

CREATE PROCEDURE [dbo].[RecuperarContrasena] ---- SIN PROBAR ----
	@Email NVARCHAR(100)
AS
BEGIN
	SELECT Contrasena
    FROM Usuarios
    WHERE Email = @Email;
END:



-----------------------------  Reservas-----------------------------
CREATE PROCEDURE sp_ObtenerReservas
AS
BEGIN
    SELECT r.ReservaID, r.UsuarioID, r.FechaReserva, r.HoraInicio, r.HoraFin, r.Estado, r.MaquinaID, 
           u.Nombre AS UsuarioNombre, m.Nombre AS MaquinaNombre
    FROM Reservas r
    INNER JOIN Usuarios u ON r.UsuarioID = u.UsuarioID
    LEFT JOIN Maquinas m ON r.MaquinaID = m.MaquinaID;
END;

Create PROCEDURE sp_InsertarReserva
    @UsuarioID INT,
    @FechaReserva DATE,
    @HoraInicio TIME,
    @HoraFin TIME,
    @MaquinaID INT = NULL -- Opcional
AS
BEGIN
    INSERT INTO Reservas (UsuarioID, FechaReserva, HoraInicio, HoraFin, MaquinaID)
    VALUES (@UsuarioID, @FechaReserva, @HoraInicio, @HoraFin, @MaquinaID);
END;

CREATE PROCEDURE sp_EliminarReserva
    @ReservaID INT
AS
BEGIN
    DELETE FROM Reservas WHERE ReservaID = @ReservaID;
END;

Create PROCEDURE sp_ActualizarEstadoReserva
    @ReservaID INT
AS
BEGIN
    UPDATE dbo.Reservas
    SET Estado = Case WHEN Estado = 1 THEN 0 Else 1 end
    WHERE ReservaID = @ReservaID;
END;

-----------------------------  Pagos-----------------------------
Create PROCEDURE sp_ObtenerPagos
AS
BEGIN
    SELECT u.Nombre AS UsuarioNombre, p.PagoID, p.UsuarioID, p.Monto, p.FechaPago, p.MetodoPago
           
    FROM Pagos p
    INNER JOIN Usuarios u ON p.UsuarioID = u.UsuarioID;
END;

CREATE PROCEDURE sp_InsertarPago
    @UsuarioID INT,
    @Monto DECIMAL(10, 2),
    @FechaPago DATE,
    @MetodoPago NVARCHAR(50)
AS
BEGIN
    INSERT INTO Pagos (UsuarioID, Monto, FechaPago, MetodoPago)
    VALUES (@UsuarioID, @Monto, @FechaPago, @MetodoPago);
END;

CREATE PROCEDURE sp_EliminarPago
    @PagoID INT
AS
BEGIN
    DELETE FROM Pagos WHERE PagoID = @PagoID;
END;

-----------------------------Ventas-----------------------------

ALTER PROCEDURE sp_ObtenerVentas
AS
BEGIN
    SELECT v.VentaID, v.UsuarioID, v.ProductoID, v.Cantidad, v.FechaVenta, v.Total, 
           u.Nombre AS UsuarioNombre, p.NombreProducto AS ProductoNombre
    FROM Ventas v
    INNER JOIN Usuarios u ON v.UsuarioID = u.UsuarioID
    INNER JOIN Productos p ON v.ProductoID = p.ProductoID;
END;


CREATE PROCEDURE sp_InsertarVenta
    @UsuarioID INT,
    @ProductoID INT,
    @Cantidad INT,
    @FechaVenta DATE,
    @Total DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO Ventas (UsuarioID, ProductoID, Cantidad, FechaVenta, Total)
    VALUES (@UsuarioID, @ProductoID, @Cantidad, @FechaVenta, @Total);
END;

CREATE PROCEDURE sp_EliminarVentas
    @VentaID INT
AS
BEGIN
    DELETE FROM Ventas WHERE VentaID = @VentaID;
END;

CREATE PROCEDURE sp_ObtenerProductos
AS
BEGIN
    -- Selecciona los productos disponibles en el inventario
    SELECT 
        ProductoID,
        NombreProducto,
        Descripcion,
        Precio,
        Stock
    FROM 
        Productos
    WHERE 
        Stock > 0; -- Filtra solo los productos que tienen stock disponible
END;







