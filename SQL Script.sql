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

----------------------------- Procedimientos Almacenados Reservas-----------------------------
CREATE PROCEDURE GetReservas
AS
BEGIN
    SELECT r.ReservaID, r.UsuarioID, r.FechaReserva, r.HoraInicio, r.HoraFin, r.Estado, r.MaquinaID, 
           u.Nombre AS UsuarioNombre, m.Nombre AS MaquinaNombre
    FROM Reservas r
    INNER JOIN Usuarios u ON r.UsuarioID = u.UsuarioID
    LEFT JOIN Maquinas m ON r.MaquinaID = m.MaquinaID;
END;

Create PROCEDURE InsertReserva
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

CREATE PROCEDURE DeleteReserva
    @ReservaID INT
AS
BEGIN
    DELETE FROM Reservas WHERE ReservaID = @ReservaID;
END;

CREATE PROCEDURE UpdateEstadoReserva
    @ReservaID INT,
    @Estado BIT
AS
BEGIN
    UPDATE Reservas
    SET Estado = @Estado
    WHERE ReservaID = @ReservaID;
END;

----------------------------- Procedimientos Almacenados Pagos-----------------------------
Create PROCEDURE GetPagos
AS
BEGIN
    SELECT u.Nombre AS UsuarioNombre, p.PagoID, p.UsuarioID, p.Monto, p.FechaPago, p.MetodoPago
           
    FROM Pagos p
    INNER JOIN Usuarios u ON p.UsuarioID = u.UsuarioID;
END;

CREATE PROCEDURE InsertPago
    @UsuarioID INT,
    @Monto DECIMAL(10, 2),
    @FechaPago DATE,
    @MetodoPago NVARCHAR(50)
AS
BEGIN
    INSERT INTO Pagos (UsuarioID, Monto, FechaPago, MetodoPago)
    VALUES (@UsuarioID, @Monto, @FechaPago, @MetodoPago);
END;

CREATE PROCEDURE DeletePago
    @PagoID INT
AS
BEGIN
    DELETE FROM Pagos WHERE PagoID = @PagoID;
END;

----------------------------- Procedimientos Almacenados Ventas-----------------------------

CREATE PROCEDURE GetVentas
AS
BEGIN
    SELECT v.VentaID, v.UsuarioID, v.ProductoID, v.Cantidad, v.FechaVenta, v.Total, 
           u.Nombre AS UsuarioNombre, p.NombreProducto AS ProductoNombre
    FROM Ventas v
    INNER JOIN Usuarios u ON v.UsuarioID = u.UsuarioID
    INNER JOIN Productos p ON v.ProductoID = p.ProductoID;
END;


CREATE PROCEDURE InsertVenta
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

CREATE PROCEDURE DeleteVenta
    @VentaID INT
AS
BEGIN
    DELETE FROM Ventas WHERE VentaID = @VentaID;
END;

----------------------------- INSERTS -----------------------------

----------------------------- Roles -----------------------------
INSERT INTO Roles (RolID, NombreRol) VALUES (1, 'Administrador');
INSERT INTO Roles (RolID, NombreRol) VALUES (2, 'Instructor');
INSERT INTO Roles (RolID, NombreRol) VALUES (3, 'Cliente');
INSERT INTO Roles (RolID, NombreRol) VALUES (4, 'Empleado');


----------------------------- Pagos -----------------------------


INSERT INTO Pagos (UsuarioID, Monto, FechaPago, MetodoPago) VALUES (1, '100', '10/11/2024', 'Tarjeta');

----------------------------- Ventas -----------------------------


INSERT INTO ventas (UsuarioID,ProductoID, Cantidad, FechaVenta, Total) VALUES (1, 1, '2', '10/15/2024', 2000);

INSERT INTO Ventas (UsuarioID, ProductoID, Cantidad, FechaVenta, Total)
VALUES (1, 2, 2, GETDATE(), 100.00);


INSERT INTO Productos(NombreProducto, Descripcion, Precio, Stock) VALUES ('Zanahorias cortadas', 'Zanahorias frescas cortadas en trocitos', '1000', '50');

INSERT INTO Productos (NombreProducto, Descripcion, Precio, Stock)
VALUES ('Proteína', 'Suplemento de proteína', 50.00, 100);

----------------------------- Usuarios -----------------------------

Insert into Usuarios (Nombre, Apellido, Email, Contrasena, Telefono, Direccion, FechaRegistro, RolID) VALUES ('Maripas','Salgado', 'maripas@gmail.com','12345','88443322','Granadilla', '10/11/2024', 1);


INSERT INTO Usuarios (Nombre, Apellido, Email, Contrasena, FechaRegistro, RolID)
VALUES ('Juan', 'Pérez', 'juan.perez@email.com', 'password', GETDATE(), 3);\



----------------------------- Maquinas -----------------------------
INSERT INTO Maquinas (Nombre, Descripcion, Ubicacion, Estado)
VALUES
('Caminadora', 'Máquina para correr o caminar.', 'Área de cardio', 1), -- Disponible
('Bicicleta Estática', 'Bicicleta para ejercicios de cardio.', 'Área de cardio', 1), -- Disponible
('Máquina de Press de Pecho', 'Entrenamiento de pecho.', 'Área de fuerza', 1), -- Disponible
('Máquina de Poleas', 'Máquina multiusos para fuerza.', 'Área de fuerza', 1), -- Disponible
('Elíptica', 'Máquina para ejercicios cardiovasculares.', 'Área de cardio', 0), -- En mantenimiento
('Banco de Pesas', 'Banco ajustable para ejercicios con pesas.', 'Área de fuerza', 1), -- Disponible
('Máquina de Piernas', 'Entrenamiento de piernas.', 'Área de fuerza', 1), -- Disponible
('Máquina de Espalda', 'Entrenamiento de espalda.', 'Área de fuerza', 1), -- Disponible
('Remo', 'Máquina para ejercicios cardiovasculares y fuerza.', 'Área de cardio', 0), -- En mantenimiento
('Escaladora', 'Máquina para ejercicios cardiovasculares.', 'Área de cardio', 1); -- Disponible



----------------------------- Reservas -----------------------------
INSERT INTO Reservas (UsuarioID, FechaReserva, HoraInicio, HoraFin, Estado, MaquinaID)
VALUES
(1, '2024-11-23', '10:00:00', '11:00:00', 1, 1), -- Caminadora
(1, '2024-11-23', '11:00:00', '12:00:00', 1, 2), -- Bicicleta Estática
(2, '2024-11-24', '09:00:00', '10:00:00', 1, 5), -- Elíptica (En mantenimiento)
(2, '2024-11-24', '14:00:00', '15:00:00', 1, NULL), -- Sin máquina específica
(1, '2024-11-25', '15:00:00', '16:30:00', 1, 4); -- Máquina de Poleas



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


