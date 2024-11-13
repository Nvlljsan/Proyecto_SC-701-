-------------------------- SP USUARIOS --------------------------
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

CREATE PROCEDURE [dbo].[UsuarioR] ---- READ ---- ---- SIN PROBAR ----
    @UsuarioID INT
AS
BEGIN
    SELECT UsuarioID, Nombre, Apellido, Email, Contrasena, Telefono, Direccion, FechaRegistro, RolID
    FROM Usuarios
    WHERE UsuarioID = @UsuarioID;
END;

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

CREATE PROCEDURE [dbo].[UsuarioD] ---- DELETE ----
    @UsuarioID INT
AS
BEGIN
    DELETE FROM Usuarios
    WHERE UsuarioID = @UsuarioID;
END;

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