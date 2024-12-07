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

----------------------------- Reservas -----------------------------
CREATE TABLE RecuperarTokens (
    TokenID INT IDENTITY(1,1) PRIMARY KEY, 
    UsuarioID INT NOT NULL,                
    Token NVARCHAR(255) NOT NULL,         
    FechaExpiracion DATETIME NOT NULL,    
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

----------------------------- Carrito -----------------------------
CREATE TABLE Carrito (
    CarritoID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT NOT NULL, 
    ProductoID INT NOT NULL, 
    Cantidad INT NOT NULL, 
    FechaAgregado DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);


----------------------------- ALTERS -----------------------------
ALTER TABLE Reservas
ADD CONSTRAINT DF_Reservas_Estado DEFAULT 1 FOR Estado;

ALTER TABLE Clientes
ALTER COLUMN FechaInicioMembresia DATE NULL;

ALTER TABLE Clientes
ALTER COLUMN FechaFinMembresia DATE NULL;

ALTER TABLE Empleados
ALTER COLUMN Puesto NVARCHAR(50) NULL;

ALTER TABLE Empleados
ALTER COLUMN FechaContratacion DATE NULL;

ALTER TABLE Instructores
ALTER COLUMN Especialidad NVARCHAR(100) NULL;

ALTER TABLE Instructores
ALTER COLUMN ExperienciaAnios INT NULL;


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
CREATE PROCEDURE [dbo].[UsuarioC]
    @Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
    @Email NVARCHAR(100),
    @Contrasena NVARCHAR(100),
    @Telefono NVARCHAR(20),
    @Direccion NVARCHAR(255),
    @RolID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Usuarios (Nombre, Apellido, Email, Contrasena, Telefono, Direccion, FechaRegistro, RolID)
    VALUES (@Nombre, @Apellido, @Email, @Contrasena, @Telefono, @Direccion, GETDATE(), @RolID);

	DECLARE @UsuarioId INT = SCOPE_IDENTITY();

        IF @RolID = 3 -- Cliente
        BEGIN
            INSERT INTO [dbo].[Clientes] (UsuarioID, MembresiaActiva, FechaInicioMembresia, FechaFinMembresia)
			VALUES (@UsuarioId, 0, GETDATE(), NULL);
        END
        ELSE IF @RolID = 2 -- Instructor
        BEGIN
            INSERT INTO [dbo].[Instructores](UsuarioID, Especialidad, ExperienciaAnios)
            VALUES (@UsuarioId, NULL, NULL); 
        END
        ELSE IF @RolID = 4 -- Empleado
        BEGIN
            INSERT INTO [dbo].[Empleados] (UsuarioID, Puesto, FechaContratacion)
            VALUES (@UsuarioId, NULL, GETDATE());
        END
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
	DELETE FROM Clientes WHERE UsuarioID = @UsuarioID;
    DELETE FROM Instructores WHERE UsuarioID = @UsuarioID;
    DELETE FROM Empleados WHERE UsuarioID = @UsuarioID;
    DELETE FROM Usuarios WHERE UsuarioID = @UsuarioID;
END;
GO

CREATE PROCEDURE UsuariosLista
AS
BEGIN
    SELECT UsuarioID, Nombre, Apellido, Email, Telefono, Direccion, FechaRegistro, RolID
    FROM Usuarios;
END;
GO

-------------------------- SP ROLES --------------------------
CREATE PROCEDURE [dbo].[RolesLista]
AS
BEGIN
    SELECT RolID, NombreRol
    FROM Roles;
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

	DECLARE @UsuarioId INT = SCOPE_IDENTITY();

    IF @RolID = 3
    BEGIN
        INSERT INTO [dbo].[Clientes] (UsuarioID, MembresiaActiva, FechaInicioMembresia, FechaFinMembresia)
        VALUES (@UsuarioId, 0, GETDATE(), NULL);
    END
END;
GO

CREATE PROCEDURE [dbo].[InicioSesion] ---- FUNCIONAL ----
	@Email NVARCHAR(100),
    	@Contrasena NVARCHAR(100)
AS
BEGIN
    SELECT UsuarioID, Nombre, Apellido, RolID
    FROM Usuarios
    WHERE Email = @Email AND Contrasena = @Contrasena;
END;
GO

CREATE PROCEDURE [dbo].[RegistrarRecuperar] ---- FUNCIONAL ----
    @Email NVARCHAR(100),           
    @Token NVARCHAR(255),           
    @FechaExpiracion DATETIME       
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Usuarios WHERE Email = @Email)
    BEGIN
        DECLARE @UsuarioID INT;
        SELECT @UsuarioID = UsuarioID FROM Usuarios WHERE Email = @Email;

        INSERT INTO RecuperarTokens (UsuarioID, Token, FechaExpiracion)
        VALUES (@UsuarioID, @Token, @FechaExpiracion);

        RETURN 0; 
    END
    ELSE
    BEGIN
        RETURN -1; 
    END
END;
GO

ALTER PROCEDURE [dbo].[RegistrarRestablecer] ---- FUNCIONAL ----
    @Token NVARCHAR(255),          
    @NuevaContrasena NVARCHAR(100) 
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UsuarioID INT;
    SELECT @UsuarioID = UsuarioID FROM RecuperarTokens WHERE Token = @Token AND FechaExpiracion > GETDATE();

    IF @UsuarioID IS NOT NULL
    BEGIN
        UPDATE Usuarios
        SET Contrasena = @NuevaContrasena
        WHERE UsuarioID = @UsuarioID;

        DELETE FROM RecuperarTokens WHERE Token = @Token;

        RETURN 0; 
    END
    ELSE
    BEGIN
        RETURN -1; 
    END
END;
GO

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
GO

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
GO

CREATE PROCEDURE sp_EliminarReserva
    @ReservaID INT
AS
BEGIN
    DELETE FROM Reservas WHERE ReservaID = @ReservaID;
END;
GO

Create PROCEDURE sp_ActualizarEstadoReserva
    @ReservaID INT
AS
BEGIN
    UPDATE dbo.Reservas
    SET Estado = Case WHEN Estado = 1 THEN 0 Else 1 end
    WHERE ReservaID = @ReservaID;
END;
GO
-----------------------------  Pagos-----------------------------
Create PROCEDURE sp_ObtenerPagos
AS
BEGIN
    SELECT u.Nombre AS UsuarioNombre, p.PagoID, p.UsuarioID, p.Monto, p.FechaPago, p.MetodoPago
           
    FROM Pagos p
    INNER JOIN Usuarios u ON p.UsuarioID = u.UsuarioID;
END;
GO

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
GO

CREATE PROCEDURE sp_EliminarPago
    @PagoID INT
AS
BEGIN
    DELETE FROM Pagos WHERE PagoID = @PagoID;
END;
GO

-----------------------------Ventas-----------------------------

CREATE PROCEDURE sp_ObtenerVentas
AS
BEGIN
    SELECT v.VentaID, v.UsuarioID, v.ProductoID, v.Cantidad, v.FechaVenta, v.Total, 
           u.Nombre AS UsuarioNombre, p.NombreProducto AS ProductoNombre
    FROM Ventas v
    INNER JOIN Usuarios u ON v.UsuarioID = u.UsuarioID
    INNER JOIN Productos p ON v.ProductoID = p.ProductoID;
END;
GO

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
GO

CREATE PROCEDURE sp_EliminarVentas
    @VentaID INT
AS
BEGIN
    DELETE FROM Ventas WHERE VentaID = @VentaID;
END;
GO

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
GO
-----------------------------Ventas-----------------------------
CREATE PROCEDURE [dbo].[CarritoAgregar]
    @UsuarioID INT,
    @ProductoID INT,
    @Cantidad INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si el UsuarioID existe
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE UsuarioID = @UsuarioID)
    BEGIN
        RAISERROR ('El UsuarioID proporcionado no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si el producto ya está en el carrito
    IF EXISTS (SELECT 1 FROM Carrito WHERE UsuarioID = @UsuarioID AND ProductoID = @ProductoID)
    BEGIN
        UPDATE Carrito
        SET Cantidad = Cantidad + @Cantidad
        WHERE UsuarioID = @UsuarioID AND ProductoID = @ProductoID;
    END
    ELSE
    BEGIN
        INSERT INTO Carrito (UsuarioID, ProductoID, Cantidad)
        VALUES (@UsuarioID, @ProductoID, @Cantidad);
    END
END;
GO

CREATE PROCEDURE [dbo].[CarritoEliminar]
    @CarritoID INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM Carrito WHERE CarritoID = @CarritoID;
END;
GO

CREATE PROCEDURE [dbo].[CarritoObtener]
    @UsuarioID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.CarritoID,
        c.ProductoID,
        p.NombreProducto,
        p.Precio,
        c.Cantidad,
        (p.Precio * c.Cantidad) AS Subtotal
    FROM 
        Carrito c
    INNER JOIN 
        Productos p ON c.ProductoID = p.ProductoID
    WHERE 
        c.UsuarioID = @UsuarioID;
END;
GO



------------------------------[UPDATES]------------------------------
----------------------------- Usuarios -----------------------------
UPDATE Usuarios
SET RolID = 1
WHERE UsuarioID = 1;





