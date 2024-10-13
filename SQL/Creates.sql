--------------------------------- Crear y usar base de datos ---------------------------------
CREATE DATABASE neon_fitness;
GO

USE neon_fitness;
GO

--------------------------------- Roles ---------------------------------
CREATE TABLE roles
(
    id_Rol     INT PRIMARY KEY IDENTITY (1,1),
    nombre     VARCHAR(50) NOT NULL UNIQUE,
);
GO

--------------------------------- Cargos ---------------------------------
CREATE TABLE cargos
(
    id_Cargo    INT PRIMARY KEY IDENTITY(1,1),
    nombre      VARCHAR(50) NOT NULL UNIQUE,
);
GO

--------------------------------- Tipo Pagos ---------------------------------
CREATE TABLE tipo_pagos
(
    id_tipo_pago     INT PRIMARY KEY IDENTITY (1,1),
    nombre_pago		 VARCHAR(50) NOT NULL UNIQUE,
);
GO

--------------------------------- Usuarios ---------------------------------
CREATE TABLE usuarios
(
    id_Usuario           INT PRIMARY KEY IDENTITY (1,1),
	cedula				 VARCHAR(20)  NOT NULL,
    nombre               VARCHAR(100) NOT NULL,
    contrasena_hash      VARCHAR(100) NOT NULL,
	num_Telefono         INT                  ,
    correo_electronico   VARCHAR(100) NOT NULL,
    id_rol               INT          NOT NULL,
    fecha_creacion       DATETIME DEFAULT GETDATE(),
	ultima_actualizacion DATETIME DEFAULT GETDATE(),
    estado               BIT      DEFAULT 1,
    CONSTRAINT fk_usuarios_rol FOREIGN KEY (id_rol) REFERENCES roles (id_Rol)
);
GO

CREATE TRIGGER trg_update_usuarios
    ON usuarios
    AFTER UPDATE
    AS
BEGIN
    UPDATE usuarios
    SET ultima_actualizacion = GETDATE()
    WHERE id_Usuario IN (SELECT id_Usuario FROM inserted);
END;
GO

--------------------------------- Personal ---------------------------------
CREATE TABLE personal
(
    id_Personal          INT PRIMARY KEY IDENTITY (1,1),
    id_usuario           INT          NOT NULL, -- referencia al usuario
	id_cargo             INT          NOT NULL, -- referencia al cargo
	descripcion          VARCHAR(255)         ,
	imagen               VARBINARY(MAX)       , -- Campo para una imagen
    fecha_nacimiento     DATE                 ,
    fecha_creacion       DATETIME DEFAULT GETDATE(),
    ultima_actualizacion DATETIME DEFAULT GETDATE(),
    estado               BIT      DEFAULT 1,
    CONSTRAINT fk_personal_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios (id_Usuario),
	CONSTRAINT fk_personal_cargo FOREIGN KEY (id_cargo) REFERENCES cargos(id_Cargo)
);
GO

CREATE TRIGGER trg_update_personal
    ON personal
    AFTER UPDATE
    AS
BEGIN
    UPDATE personal
    SET ultima_actualizacion = GETDATE()
    WHERE id_Personal IN (SELECT id_Personal FROM inserted);
END;
GO

CREATE TRIGGER trg_insert_personal
ON usuarios
AFTER INSERT
AS
BEGIN
    INSERT INTO personal(id_usuario, fecha_creacion, ultima_actualizacion)
    SELECT id_Usuario, GETDATE(), GETDATE()
    FROM inserted
    WHERE id_rol = 2;  -- Rol de personal
END;
GO

CREATE TRIGGER trg_update_Rol_personal
ON usuarios
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Eliminar si se cambio el rol de personal
    DELETE FROM personal
    WHERE id_usuario IN (SELECT id_usuario FROM inserted WHERE id_rol <> 2);

    -- Insertar o actualizar si el rol se cambio a personal
    MERGE INTO personal AS target
    USING (SELECT id_usuario FROM inserted WHERE id_rol = 2) AS source
    ON target.id_usuario = source.id_usuario
    WHEN NOT MATCHED THEN
        INSERT (id_usuario, descripcion, imagen, fecha_nacimiento, fecha_creacion, ultima_actualizacion)
        VALUES (source.id_usuario, NULL, NULL, NULL, GETDATE(), GETDATE())
    WHEN MATCHED THEN
        UPDATE SET ultima_actualizacion = GETDATE();
END;
GO

--------------------------------- Clientes ---------------------------------
CREATE TABLE clientes
(
    id_Cliente           INT PRIMARY KEY IDENTITY (1,1),
    id_usuario           INT          NOT NULL, -- referencia al cliente
	imagen               VARBINARY(MAX)       , -- Campo para una la imagen
    fecha_nacimiento     DATE				  ,
    fecha_creacion       DATETIME DEFAULT GETDATE(),
    ultima_actualizacion DATETIME DEFAULT GETDATE(),
    estado               BIT      DEFAULT 1,
    CONSTRAINT fk_clientes_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios (id_Usuario)
);
GO

CREATE TRIGGER trg_update_cliente
    ON clientes
    AFTER UPDATE
    AS
BEGIN
    UPDATE clientes
    SET ultima_actualizacion = GETDATE()
    WHERE id_Cliente IN (SELECT id_Cliente FROM inserted);
END;
GO

CREATE TRIGGER trg_insert_cliente
ON usuarios
AFTER INSERT
AS
BEGIN
    INSERT INTO clientes (id_usuario, fecha_creacion, ultima_actualizacion)
    SELECT id_Usuario, GETDATE(), GETDATE()
    FROM inserted
    WHERE id_rol = 3;  -- Rol de clientes
END;
GO

CREATE TRIGGER trg_update_Rol_Clientes
ON usuarios
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Eliminar si se cambio el rol de cliente
    DELETE FROM clientes
    WHERE id_usuario IN (SELECT id_usuario FROM inserted WHERE id_rol <> 3);

    -- Insertar o actualizar si el rol se cambio a cliente
    MERGE INTO clientes AS target
    USING (SELECT id_usuario FROM inserted WHERE id_rol = 3) AS source
    ON target.id_usuario = source.id_usuario
    WHEN NOT MATCHED THEN
        INSERT (id_usuario, imagen, fecha_nacimiento, fecha_creacion, ultima_actualizacion)
        VALUES (source.id_usuario, NULL, NULL, GETDATE(), GETDATE())
    WHEN MATCHED THEN
        UPDATE SET ultima_actualizacion = GETDATE(); 
END;
GO

--------------------------------- Productos ---------------------------------
CREATE TABLE productos
(
    id_Producto          INT PRIMARY KEY IDENTITY(1,1),
    nombre               VARCHAR(100)	NOT NULL,
    descripcion          VARCHAR(255)           ,
    precio               DECIMAL(10,2)  NOT NULL,
    cantidad             INT			NOT NULL,
	imagen               VARBINARY(MAX)         ,
    fecha_creacion       DATETIME DEFAULT GETDATE(),
    ultima_actualizacion DATETIME DEFAULT GETDATE(),
    estado               BIT DEFAULT 1
);
GO

--------------------------------- Proveedores ---------------------------------
CREATE TABLE proveedores
(
    id_Proveedor         INT PRIMARY KEY IDENTITY(1,1),
    nombre               VARCHAR(100)	NOT NULL,
    telefono             VARCHAR(20)			,
    correo_electronico   VARCHAR(100)			,
    direccion            VARCHAR(255)			,
    fecha_creacion       DATETIME DEFAULT GETDATE(),
    ultima_actualizacion DATETIME DEFAULT GETDATE(),
    estado               BIT DEFAULT 1
);
GO

--------------------------------- Facturas ---------------------------------
CREATE TABLE facturas
(
    id_Factura           INT PRIMARY KEY IDENTITY(1,1),
    id_Cliente           INT					NOT NULL, -- Referencia al cliente
    id_Personal          INT					NOT NULL, -- Referencia al personal 
    fecha_emision        DATETIME DEFAULT GETDATE()		,
    total                DECIMAL(10,2)			NOT NULL,
    descuento            DECIMAL(10,2) DEFAULT 0		, -- En caso de que haya algun descuento
    total_final          DECIMAL(10,2)			NOT NULL, -- Total si se aplicaron descuentos o no
    estado               BIT DEFAULT 1					,
    CONSTRAINT fk_factura_cliente FOREIGN KEY (id_Cliente) REFERENCES clientes(id_Cliente),
    CONSTRAINT fk_factura_personal FOREIGN KEY (id_Personal) REFERENCES personal(id_Personal)
);
GO

--------------------------------- Detalles Factura ---------------------------------
CREATE TABLE detalles_factura
(
    id_DetalleFactura    INT PRIMARY KEY IDENTITY(1,1),
    id_Factura           INT		    NOT NULL, -- Referencia a la factura
    id_Producto          INT			NOT NULL, -- Referencia al producto
    cantidad             INT			NOT NULL, 
    precio_unitario      DECIMAL(10,2)  NOT NULL,
    subtotal             DECIMAL(10,2)  NOT NULL, -- Precio de cantidad y precio por unidad
    CONSTRAINT fk_detalle_factura_factura FOREIGN KEY (id_Factura) REFERENCES facturas(id_Factura),
    CONSTRAINT fk_detalle_factura_producto FOREIGN KEY (id_Producto) REFERENCES productos(id_Producto)
);
GO

--------------------------------- Pagos ---------------------------------
CREATE TABLE pagos
(
    id_Pago              INT PRIMARY KEY IDENTITY(1,1),
    id_Factura           INT				NOT NULL, -- Referencia a la factura
    id_tipo_pago         INT				NOT NULL, -- Referencia al tipo de pago
    monto_pagado         DECIMAL(10,2)		NOT NULL, 
    fecha_pago           DATETIME DEFAULT GETDATE() , 
    CONSTRAINT fk_pago_factura FOREIGN KEY (id_Factura) REFERENCES facturas(id_Factura),
    CONSTRAINT fk_pago_tipo FOREIGN KEY (id_tipo_pago) REFERENCES tipo_pagos(id_tipo_pago)
);

--------------------------------- Indices ---------------------------------
CREATE INDEX idx_usuarios_rol ON usuarios (id_rol);
GO

CREATE INDEX idx_facturas_cliente_personal ON facturas(id_Cliente, id_Personal);
GO

CREATE INDEX idx_pagos_id_factura ON pagos(id_Factura);
GO

CREATE INDEX idx_detalles_factura_id_factura ON detalles_factura(id_Factura);
GO
