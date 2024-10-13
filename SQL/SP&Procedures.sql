USE neon_fitness;
GO

-------------------------------------------- SPs --------------------------------------------
-- Crear Usuario
CREATE PROCEDURE GestionarUsuario 
    @IdUsuario INT = NULL,
    @Cedula VARCHAR(20),
    @Nombre VARCHAR(100),
    @Contrasena VARCHAR(100),
    @Num_Telefono INT,
    @CorreoElectronico VARCHAR(100),
    @IdRol INT,
    @FechaCreacion DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @IdUsuario IS NULL
    BEGIN
        -- Ver si el usuario existe
        IF EXISTS (SELECT 1 FROM usuarios WHERE nombre = @Nombre)
        BEGIN
            RAISERROR ('El nombre de usuario ya existe.', 16, 1);
            RETURN;
        END

        -- Ingresar nuevo usuario
        INSERT INTO usuarios (cedula, nombre, contrasena_hash, num_Telefono, correo_electronico, id_rol, fecha_creacion, ultima_actualizacion)
        VALUES (@Cedula, @Nombre, @Contrasena, @Num_Telefono, @CorreoElectronico, @IdRol, GETDATE(), GETDATE());
    END
    ELSE
    BEGIN
        -- Actualización de un usaurio
        UPDATE usuarios
        SET cedula              = @Cedula,
            nombre              = @Nombre,
            contrasena_hash     = @Contrasena,
            num_Telefono        = @Num_Telefono,
            correo_electronico  = @CorreoElectronico,
            id_rol              = @IdRol,
            ultima_actualizacion = GETDATE()
        WHERE id_Usuario = @IdUsuario;
    END
END;
GO

-- Actualizar Personal
CREATE PROCEDURE GestionarPersonal
    @IdPersonal INT = NULL,    
    @IdUsuario INT,              
    @IdCargo INT,                
    @Descripcion VARCHAR(255),    
    @Imagen VARBINARY(MAX),     
    @FechaNacimiento DATE        
AS
BEGIN
    IF @IdPersonal IS NULL
    BEGIN
        -- Inserción de nuevo personal
        INSERT INTO personal (id_usuario, id_cargo, descripcion, imagen, fecha_nacimiento, fecha_creacion, ultima_actualizacion)
        VALUES (@IdUsuario, @IdCargo, @Descripcion, @Imagen, @FechaNacimiento, GETDATE(), GETDATE());
    END
    ELSE
    BEGIN
        -- Actualización de personal existente
        UPDATE personal
        SET id_usuario           = @IdUsuario,
            id_cargo             = @IdCargo,
            descripcion          = @Descripcion,
            imagen               = @Imagen,
            fecha_nacimiento     = @FechaNacimiento,
            ultima_actualizacion = GETDATE()
        WHERE id_Personal = @IdPersonal;
    END
END;
GO

CREATE PROCEDURE RegistrarPago
    @IdFactura INT,                -- Referencia a la factura asociada
    @IdTipoPago INT,               -- Referencia al tipo de pago
    @MontoPagado DECIMAL(10, 2),   -- Monto pagado
    @MetodoPago VARCHAR(50),        -- Método de pago (efectivo, tarjeta, etc.)
    @FechaPago DATETIME = GETDATE() -- Fecha del pago (opcional, por defecto la fecha actual)
AS
BEGIN
    INSERT INTO pagos (id_Factura, id_tipo_pago, monto_pagado, metodo_pago, fecha_pago, fecha_creacion, ultima_actualizacion)
    VALUES (@IdFactura, @IdTipoPago, @MontoPagado, @MetodoPago, @FechaPago, GETDATE(), GETDATE());
END;
GO


-------------------------------------------- VISTAS --------------------------------------------


-- Vista de Usuarios por Rol
CREATE VIEW vw_usuarios_rol AS
SELECT u.id_Usuario, u.nombre, r.nombre AS rol
FROM usuarios u
         JOIN roles r ON u.id_rol = r.id_Rol
WHERE u.activo = 1;
GO

-- Vista de Pagos por Cliente
CREATE VIEW vw_pagos_cliente AS
SELECT 
    p.id_Pago,
    c.id_Cliente,
    c.nombre AS NombreCliente,
    p.fecha_pago,
    p.monto_pagado,
    p.metodo_pago,
    tp.nombre_tipo_pago AS TipoPago,
    f.total AS TotalFactura,
    f.descuento AS DescuentoFactura,
    f.total_final AS TotalFinalFactura
FROM 
    pagos p
		JOIN	facturas f ON p.id_Factura = f.id_Factura
		JOIN	clientes c ON f.id_Cliente = c.id_Cliente
		JOIN	tipo_pagos tp ON p.id_tipo_pago = tp.id_tipo_pago
WHERE p.estado = 1; 
GO





-------------------------------------------- Validar Inserts --------------------------------------------
SELECT 'cargos', COUNT(*)
FROM cargos
UNION ALL
SELECT 'pagos', COUNT(*)
FROM pagos
UNION ALL
SELECT 'clientes', COUNT(*)
FROM clientes
UNION ALL
SELECT 'detalles_factura', COUNT(*)
FROM detalles_factura
UNION ALL
SELECT 'facturas', COUNT(*)
FROM facturas
UNION ALL
SELECT 'personal', COUNT(*)
FROM personal
UNION ALL
SELECT 'roles', COUNT(*)
FROM roles
UNION ALL
SELECT 'tipo_pagos', COUNT(*)
FROM tipo_pagos
UNION ALL
SELECT 'productos', COUNT(*)
FROM productos
UNION ALL
SELECT 'proveedores', COUNT(*)
FROM proveedores
UNION ALL
SELECT 'usuarios', COUNT(*)
FROM usuarios;