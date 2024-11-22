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


------------------------------------------------------------

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

----------------------------------------------------------------

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

---------------------------------------------------------------------

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
END

-----------------------------------------------------------------------

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

----------------------------------------------------------------------

CREATE PROCEDURE ObtenerEmpleados
AS
BEGIN
    SET NOCOUNT ON;

    SELECT e.EmpleadoID, e.UsuarioID, e.Puesto, e.FechaContratacion, 
           u.Nombre, u.Apellido, u.Email, u.Telefono
    FROM Empleados e
    INNER JOIN Usuarios u ON e.UsuarioID = u.UsuarioID;
END;

----------------------------------------------------------------------

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

--------------------------------------------------------------------------

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

--------------------------------------------------------------------------

CREATE PROCEDURE ObtenerUsuariosParaEmpleados
AS
BEGIN
    SET NOCOUNT ON;

    SELECT UsuarioID, Nombre, Apellido 
    FROM Usuarios 
    WHERE RolID = 4;
END;

--------------------------------------------------------------------------

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

--------------------------------------------------------------------------

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
END

--------------------------------------------------------------------------

CREATE PROCEDURE sp_ActualizarUsuario
    @UsuarioID INT,
    @Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
    @Email NVARCHAR(100),
    @Telefono NVARCHAR(20),
    @Direccion NVARCHAR(255)
AS
BEGIN
    UPDATE Usuarios
    SET 
        Nombre = @Nombre,
        Apellido = @Apellido,
        Email = @Email,
        Telefono = @Telefono,
        Direccion = @Direccion
    WHERE UsuarioID = @UsuarioID;
END

--------------------------------------------------------------------------

CREATE PROCEDURE sp_GetEmpleados
AS
BEGIN
    SELECT 
        e.EmpleadoID,
        e.UsuarioID,
        e.Puesto,
        e.FechaContratacion,
        u.Nombre,
        u.Apellido,
        u.Email,
        u.Telefono,
        u.Direccion
    FROM Empleados e
    INNER JOIN Usuarios u ON e.UsuarioID = u.UsuarioID;
END

--------------------------------------------------------------------------

CREATE PROCEDURE sp_InsertarEmpleado
    @UsuarioID INT,
    @Puesto NVARCHAR(50),
    @FechaContratacion DATE
AS
BEGIN
    INSERT INTO Empleados (UsuarioID, Puesto, FechaContratacion)
    VALUES (@UsuarioID, @Puesto, @FechaContratacion);

    SELECT SCOPE_IDENTITY(); 
END

--------------------------------------------------------------------------

CREATE PROCEDURE sp_InsertarUsuario
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
    VALUES (@Nombre, @Apellido, @Email, @Contrasena, @Telefono, @Direccion, @FechaRegistro, @RolID);

    SELECT SCOPE_IDENTITY(); 
END

--------------------------------------------------------------------------