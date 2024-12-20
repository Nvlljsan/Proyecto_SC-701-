USE [master]
GO
/****** Object:  Database [NeonFitnessDB]    Script Date: 12/21/2024 8:24:20 AM ******/
CREATE DATABASE [NeonFitnessDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'NeonFitnessDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\NeonFitnessDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'NeonFitnessDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\NeonFitnessDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [NeonFitnessDB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [NeonFitnessDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [NeonFitnessDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [NeonFitnessDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [NeonFitnessDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [NeonFitnessDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [NeonFitnessDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET RECOVERY FULL 
GO
ALTER DATABASE [NeonFitnessDB] SET  MULTI_USER 
GO
ALTER DATABASE [NeonFitnessDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [NeonFitnessDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [NeonFitnessDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [NeonFitnessDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [NeonFitnessDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [NeonFitnessDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'NeonFitnessDB', N'ON'
GO
ALTER DATABASE [NeonFitnessDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [NeonFitnessDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [NeonFitnessDB]
GO
/****** Object:  Table [dbo].[Carrito]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Carrito](
	[CarritoID] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NOT NULL,
	[ProductoID] [int] NOT NULL,
	[Cantidad] [int] NOT NULL,
	[FechaAgregado] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CarritoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clientes]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clientes](
	[ClienteID] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NULL,
	[MembresiaActiva] [bit] NOT NULL,
	[FechaInicioMembresia] [date] NULL,
	[FechaFinMembresia] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[ClienteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Empleados]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Empleados](
	[EmpleadoID] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NULL,
	[Puesto] [nvarchar](50) NULL,
	[FechaContratacion] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[EmpleadoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HistorialCompras]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HistorialCompras](
	[CompraID] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NOT NULL,
	[ProductoID] [int] NOT NULL,
	[Cantidad] [int] NOT NULL,
	[FechaCompra] [datetime] NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CompraID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Instructores]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Instructores](
	[InstructorID] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NULL,
	[Especialidad] [nvarchar](100) NULL,
	[ExperienciaAnios] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[InstructorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MantenimientoMaquinas]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MantenimientoMaquinas](
	[MantenimientoID] [int] IDENTITY(1,1) NOT NULL,
	[EmpleadoID] [int] NULL,
	[MaquinaID] [int] NULL,
	[FechaMantenimiento] [date] NOT NULL,
	[Descripcion] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[MantenimientoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Maquinas]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Maquinas](
	[MaquinaID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Descripcion] [nvarchar](255) NULL,
	[Ubicacion] [nvarchar](100) NULL,
	[Estado] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaquinaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pagos]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pagos](
	[PagoID] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NULL,
	[Monto] [decimal](10, 2) NOT NULL,
	[FechaPago] [date] NOT NULL,
	[MetodoPago] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[PagoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Productos]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Productos](
	[ProductoID] [int] IDENTITY(1,1) NOT NULL,
	[NombreProducto] [nvarchar](100) NOT NULL,
	[Descripcion] [nvarchar](255) NULL,
	[Precio] [decimal](10, 2) NOT NULL,
	[Stock] [int] NOT NULL,
	[Imagen] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RecuperarTokens]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecuperarTokens](
	[TokenID] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NOT NULL,
	[Token] [nvarchar](255) NOT NULL,
	[FechaExpiracion] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TokenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservas]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservas](
	[ReservaID] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NULL,
	[FechaReserva] [date] NOT NULL,
	[HoraInicio] [time](7) NOT NULL,
	[HoraFin] [time](7) NOT NULL,
	[Estado] [bit] NOT NULL,
	[MaquinaID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ReservaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[RolID] [int] NOT NULL,
	[NombreRol] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RolID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
	[UsuarioID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
	[Apellido] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[Contrasena] [nvarchar](100) NOT NULL,
	[Telefono] [nvarchar](20) NULL,
	[Direccion] [nvarchar](255) NULL,
	[FechaRegistro] [date] NOT NULL,
	[RolID] [int] NULL,
	[Activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UsuarioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ventas]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ventas](
	[VentaID] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NULL,
	[ProductoID] [int] NULL,
	[Cantidad] [int] NOT NULL,
	[FechaVenta] [date] NOT NULL,
	[Total] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[VentaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Clientes] ON 

INSERT [dbo].[Clientes] ([ClienteID], [UsuarioID], [MembresiaActiva], [FechaInicioMembresia], [FechaFinMembresia]) VALUES (1, 1, 0, CAST(N'2024-12-20' AS Date), NULL)
INSERT [dbo].[Clientes] ([ClienteID], [UsuarioID], [MembresiaActiva], [FechaInicioMembresia], [FechaFinMembresia]) VALUES (26, 1047, 0, CAST(N'2024-12-20' AS Date), NULL)
SET IDENTITY_INSERT [dbo].[Clientes] OFF
GO
SET IDENTITY_INSERT [dbo].[HistorialCompras] ON 

INSERT [dbo].[HistorialCompras] ([CompraID], [UsuarioID], [ProductoID], [Cantidad], [FechaCompra], [Total]) VALUES (1, 1, 14, 1, CAST(N'2024-12-20T21:46:51.640' AS DateTime), CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[HistorialCompras] ([CompraID], [UsuarioID], [ProductoID], [Cantidad], [FechaCompra], [Total]) VALUES (2, 1, 14, 2, CAST(N'2024-12-20T22:03:14.590' AS DateTime), CAST(2.00 AS Decimal(18, 2)))
INSERT [dbo].[HistorialCompras] ([CompraID], [UsuarioID], [ProductoID], [Cantidad], [FechaCompra], [Total]) VALUES (3, 1, 1018, 3, CAST(N'2024-12-20T22:08:12.417' AS DateTime), CAST(27000.00 AS Decimal(18, 2)))
INSERT [dbo].[HistorialCompras] ([CompraID], [UsuarioID], [ProductoID], [Cantidad], [FechaCompra], [Total]) VALUES (4, 1, 1018, 1, CAST(N'2024-12-20T22:51:07.090' AS DateTime), CAST(9000.00 AS Decimal(18, 2)))
INSERT [dbo].[HistorialCompras] ([CompraID], [UsuarioID], [ProductoID], [Cantidad], [FechaCompra], [Total]) VALUES (5, 1, 14, 1, CAST(N'2024-12-20T22:51:07.090' AS DateTime), CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[HistorialCompras] ([CompraID], [UsuarioID], [ProductoID], [Cantidad], [FechaCompra], [Total]) VALUES (6, 1, 14, 1, CAST(N'2024-12-20T22:59:16.090' AS DateTime), CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[HistorialCompras] ([CompraID], [UsuarioID], [ProductoID], [Cantidad], [FechaCompra], [Total]) VALUES (7, 1, 1018, 1, CAST(N'2024-12-20T22:59:40.420' AS DateTime), CAST(9000.00 AS Decimal(18, 2)))
INSERT [dbo].[HistorialCompras] ([CompraID], [UsuarioID], [ProductoID], [Cantidad], [FechaCompra], [Total]) VALUES (8, 1, 1018, 1, CAST(N'2024-12-21T08:00:09.823' AS DateTime), CAST(9000.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[HistorialCompras] OFF
GO
SET IDENTITY_INSERT [dbo].[Maquinas] ON 

INSERT [dbo].[Maquinas] ([MaquinaID], [Nombre], [Descripcion], [Ubicacion], [Estado]) VALUES (1, N'Maquina Prueba', N'Prueba de la funcionalidad de la maquina', N'Heredia', 1)
SET IDENTITY_INSERT [dbo].[Maquinas] OFF
GO
INSERT [dbo].[Roles] ([RolID], [NombreRol]) VALUES (1, N'Administrador')
INSERT [dbo].[Roles] ([RolID], [NombreRol]) VALUES (2, N'Instructor')
INSERT [dbo].[Roles] ([RolID], [NombreRol]) VALUES (3, N'Cliente')
INSERT [dbo].[Roles] ([RolID], [NombreRol]) VALUES (4, N'Empleado')
GO
SET IDENTITY_INSERT [dbo].[Usuarios] ON 

INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Contrasena], [Telefono], [Direccion], [FechaRegistro], [RolID], [Activo]) VALUES (1, N'Maripas', N'Salgado', N'maripas.salgado.fernandez@gmail.com', N'ctv5LhO9pzXhRz7SgVqiMQ==', N'84371496', N'San Rafael, Puriscal', CAST(N'2024-12-20' AS Date), 1, 1)
INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Contrasena], [Telefono], [Direccion], [FechaRegistro], [RolID], [Activo]) VALUES (3, N'Juan Diego', N'Sanchez Gamboa', N'jsanchez10087@ufide.ac.cr', N'N2PPYzzs1UOOK+/QIlHpXQ==', N'84558725', N'San Pablo, Heredia', CAST(N'2024-11-23' AS Date), 1, 1)
INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Contrasena], [Telefono], [Direccion], [FechaRegistro], [RolID], [Activo]) VALUES (21, N'Juan Diego (Cliente)', N'(Version Cliente)', N'juan1@email.com', N'NMPmYkSQZ27CTRI8mM+QnA==', N'22446688', N'San Pablo, Heredia', CAST(N'2024-12-06' AS Date), 3, 1)
INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Contrasena], [Telefono], [Direccion], [FechaRegistro], [RolID], [Activo]) VALUES (22, N'Juan Diego (Empleado)', N'(Version Empleado)', N'juan2@email.com', N'NMPmYkSQZ27CTRI8mM+QnA==', N'11335577', N'San Pablo, Heredia', CAST(N'2024-12-07' AS Date), 4, 1)
INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Contrasena], [Telefono], [Direccion], [FechaRegistro], [RolID], [Activo]) VALUES (23, N'Juan Diego (Instructor)', N'(Version Instructor)', N'juan3@email.com', N'NMPmYkSQZ27CTRI8mM+QnA==', N'11224455', N'San Pablo, Heredia', CAST(N'2024-12-07' AS Date), 2, 1)
INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Contrasena], [Telefono], [Direccion], [FechaRegistro], [RolID], [Activo]) VALUES (1031, N'Registro Prueba', N'Comprobar funcionalidad', N'prueba@example.com', N'NMPmYkSQZ27CTRI8mM+QnA==', N'11223344', N'San Pablo, Heredia', CAST(N'2024-12-13' AS Date), 3, 1)
INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Contrasena], [Telefono], [Direccion], [FechaRegistro], [RolID], [Activo]) VALUES (1032, N'Create Prueba', N'Comprobar funcionalidad', N'create@example.com', N'NMPmYkSQZ27CTRI8mM+QnA==', N'44332211', N'San Pablo, Heredia', CAST(N'2024-12-13' AS Date), 1, 1)
INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Contrasena], [Telefono], [Direccion], [FechaRegistro], [RolID], [Activo]) VALUES (1042, N'nuevo', N'activo', N'activo@email.com', N'NMPmYkSQZ27CTRI8mM+QnA==', N'12321231', N'Calle 45, Alajuela', CAST(N'2024-12-18' AS Date), 3, 1)
INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Contrasena], [Telefono], [Direccion], [FechaRegistro], [RolID], [Activo]) VALUES (1043, N'create', N'activo', N'activo1@email.com', N'NMPmYkSQZ27CTRI8mM+QnA==', N'23232125', N'1', CAST(N'2024-12-18' AS Date), 3, 1)
INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Contrasena], [Telefono], [Direccion], [FechaRegistro], [RolID], [Activo]) VALUES (1045, N'Marcelo', N'Saenz', N'marcelo@email.com', N'NMPmYkSQZ27CTRI8mM+QnA==', N'22446644', N'San Pablo, Heredia', CAST(N'2024-12-18' AS Date), 3, 0)
INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Contrasena], [Telefono], [Direccion], [FechaRegistro], [RolID], [Activo]) VALUES (1046, N'gdfg', N'fsdfsd', N'sfda@email.com', N'NMPmYkSQZ27CTRI8mM+QnA==', N'88843421', N'San Pablo, Heredia', CAST(N'2024-12-20' AS Date), 2, 0)
INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Contrasena], [Telefono], [Direccion], [FechaRegistro], [RolID], [Activo]) VALUES (1047, N'juanito', N'Pereira', N'juanito@gmail.com', N'ctv5LhO9pzXhRz7SgVqiMQ==', N'88888888', N'asdasdasd', CAST(N'2024-12-20' AS Date), 3, 1)
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO
ALTER TABLE [dbo].[Carrito] ADD  DEFAULT (getdate()) FOR [FechaAgregado]
GO
ALTER TABLE [dbo].[Reservas] ADD  CONSTRAINT [DF_Reservas_Estado]  DEFAULT ((1)) FOR [Estado]
GO
ALTER TABLE [dbo].[Usuarios] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Carrito]  WITH CHECK ADD FOREIGN KEY([ProductoID])
REFERENCES [dbo].[Productos] ([ProductoID])
GO
ALTER TABLE [dbo].[Carrito]  WITH CHECK ADD FOREIGN KEY([ProductoID])
REFERENCES [dbo].[Productos] ([ProductoID])
GO
ALTER TABLE [dbo].[Carrito]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[Carrito]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[Clientes]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[Clientes]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[Empleados]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[Empleados]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[Instructores]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[Instructores]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[MantenimientoMaquinas]  WITH CHECK ADD FOREIGN KEY([EmpleadoID])
REFERENCES [dbo].[Empleados] ([EmpleadoID])
GO
ALTER TABLE [dbo].[MantenimientoMaquinas]  WITH CHECK ADD FOREIGN KEY([EmpleadoID])
REFERENCES [dbo].[Empleados] ([EmpleadoID])
GO
ALTER TABLE [dbo].[MantenimientoMaquinas]  WITH CHECK ADD FOREIGN KEY([MaquinaID])
REFERENCES [dbo].[Maquinas] ([MaquinaID])
GO
ALTER TABLE [dbo].[MantenimientoMaquinas]  WITH CHECK ADD FOREIGN KEY([MaquinaID])
REFERENCES [dbo].[Maquinas] ([MaquinaID])
GO
ALTER TABLE [dbo].[Pagos]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[Pagos]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[RecuperarTokens]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[RecuperarTokens]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[Reservas]  WITH CHECK ADD FOREIGN KEY([MaquinaID])
REFERENCES [dbo].[Maquinas] ([MaquinaID])
GO
ALTER TABLE [dbo].[Reservas]  WITH CHECK ADD FOREIGN KEY([MaquinaID])
REFERENCES [dbo].[Maquinas] ([MaquinaID])
GO
ALTER TABLE [dbo].[Reservas]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[Reservas]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD FOREIGN KEY([RolID])
REFERENCES [dbo].[Roles] ([RolID])
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD FOREIGN KEY([RolID])
REFERENCES [dbo].[Roles] ([RolID])
GO
ALTER TABLE [dbo].[Ventas]  WITH CHECK ADD FOREIGN KEY([ProductoID])
REFERENCES [dbo].[Productos] ([ProductoID])
GO
ALTER TABLE [dbo].[Ventas]  WITH CHECK ADD FOREIGN KEY([ProductoID])
REFERENCES [dbo].[Productos] ([ProductoID])
GO
ALTER TABLE [dbo].[Ventas]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[Ventas]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
/****** Object:  StoredProcedure [dbo].[ActualizarCliente]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------- STORED PROCEDURES ----------------------------
----------------------------- Clientes ----------------------------
Create PROCEDURE [dbo].[ActualizarCliente]
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
/****** Object:  StoredProcedure [dbo].[ActualizarContrasena]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ActualizarContrasena]
    @UsuarioID INT,
    @NuevaContrasena NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Usuarios
    SET Contrasena = @NuevaContrasena
    WHERE UsuarioID = @UsuarioID;

END;
GO
/****** Object:  StoredProcedure [dbo].[ActualizarTokens]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ActualizarTokens]
    @UsuarioID INT,                -- ID del usuario
    @Token NVARCHAR(255),          -- Nuevo refresh token (encriptado)
    @FechaExpiracion DATETIME      -- Fecha de expiración del nuevo token
AS
BEGIN
    SET NOCOUNT ON;

    -- Invalida todos los refresh tokens anteriores del usuario
    DELETE FROM RecuperarTokens 
    WHERE UsuarioID = @UsuarioID;

    -- Inserta el nuevo token
    INSERT INTO RecuperarTokens (UsuarioID, Token, FechaExpiracion)
    VALUES (@UsuarioID, @Token, @FechaExpiracion);

    RETURN 0; -- Operación exitosa
END;
GO
/****** Object:  StoredProcedure [dbo].[AgregarEmpleado]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
CREATE PROCEDURE [dbo].[AgregarEmpleado]
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
/****** Object:  StoredProcedure [dbo].[AgregarInstructor]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AgregarInstructor]
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
/****** Object:  StoredProcedure [dbo].[CarritoAgregar]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CarritoAgregar]
    @UsuarioID INT,
    @ProductoID INT,
    @Cantidad INT
AS
BEGIN
    BEGIN TRY
        -- Inicia una transacción
        BEGIN TRANSACTION;

        -- Verifica si el stock es suficiente
        IF (SELECT Stock FROM Productos WHERE ProductoID = @ProductoID) < @Cantidad
        BEGIN
            THROW 50000, 'Stock insuficiente para agregar el producto al carrito.', 1;
        END

        -- Reduce el stock del producto
        UPDATE Productos
        SET Stock = Stock - @Cantidad
        WHERE ProductoID = @ProductoID;

        -- Verifica si el producto ya está en el carrito
        IF (SELECT COUNT(*) FROM Carrito WHERE UsuarioID = @UsuarioID AND ProductoID = @ProductoID) = 0
        BEGIN
            INSERT INTO Carrito (UsuarioID, ProductoID, Cantidad, FechaAgregado)
            VALUES (@UsuarioID, @ProductoID, @Cantidad, GETDATE());
        END
        ELSE
        BEGIN
            UPDATE Carrito
            SET Cantidad = Cantidad + @Cantidad, -- Suma la cantidad al carrito existente
                FechaAgregado = GETDATE()
            WHERE UsuarioID = @UsuarioID 
              AND ProductoID = @ProductoID;
        END

        -- Confirma la transacción
        COMMIT TRANSACTION;
        RETURN 1;
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, revierte la transacción
        ROLLBACK TRANSACTION;

        -- Lanza el error original
        THROW;
    END CATCH
END;

GO
/****** Object:  StoredProcedure [dbo].[CarritoEliminar]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CarritoEliminar]
      @CarritoID INT
AS
BEGIN
    BEGIN TRY
        -- Inicia una transacción
        BEGIN TRANSACTION;

        -- Obtén el ProductoID y la Cantidad desde el carrito
        DECLARE @ProductoID INT;
        DECLARE @Cantidad INT;

        SELECT @ProductoID = ProductoID, @Cantidad = Cantidad
        FROM Carrito
        WHERE CarritoID = @CarritoID;

        -- Si el producto existe en el carrito, restaura el stock
        IF (@ProductoID IS NOT NULL AND @Cantidad IS NOT NULL)
        BEGIN
            UPDATE Productos
            SET Stock = Stock + @Cantidad
            WHERE ProductoID = @ProductoID;

            -- Elimina el producto del carrito
            DELETE FROM Carrito
            WHERE CarritoID = @CarritoID;
        END

        -- Confirma la transacción
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, revierte la transacción
        ROLLBACK TRANSACTION;

        -- Lanza el error original
        THROW;
    END CATCH
END;

GO
/****** Object:  StoredProcedure [dbo].[CarritoObtener]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CarritoObtener]
    @UsuarioID INT
AS
BEGIN
    SELECT 
        c.CarritoID,
        c.UsuarioID,
        c.ProductoID,
        c.Cantidad,
        p.NombreProducto AS NombreProducto,
        p.Descripcion AS Descripcion,
		p.Precio AS Precio

    FROM 
        Carrito c
    INNER JOIN 
        Productos p ON c.ProductoID = p.ProductoID
    WHERE 
        c.UsuarioID = @UsuarioID;
END;

GO
/****** Object:  StoredProcedure [dbo].[CarritoSimularPago]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CarritoSimularPago]
   @UsuarioID INT
AS
BEGIN
    BEGIN TRY
        -- Inicia una transacción
        BEGIN TRANSACTION;

        -- Verifica si el carrito tiene productos
        IF NOT EXISTS (SELECT * FROM Carrito WHERE UsuarioID = @UsuarioID)
        BEGIN
            THROW 50000, 'El carrito está vacío. No se puede procesar el pago.', 1;
        END

        -- Inserta los productos del carrito en la tabla Ventas
        INSERT INTO Ventas (UsuarioID, ProductoID, Cantidad, FechaVenta, Total)
        SELECT 
            c.UsuarioID,
            c.ProductoID,
            c.Cantidad,
            GETDATE() AS FechaVenta,
            c.Cantidad * p.Precio AS Total
        FROM 
            Carrito c
        INNER JOIN 
            Productos p ON c.ProductoID = p.ProductoID
        WHERE 
            c.UsuarioID = @UsuarioID;

        -- Inserta los productos del carrito en la tabla HistorialCompras
        INSERT INTO HistorialCompras (UsuarioID, ProductoID, Cantidad, FechaCompra, Total)
        SELECT 
            c.UsuarioID,
            c.ProductoID,
            c.Cantidad,
            GETDATE() AS FechaCompra,
            c.Cantidad * p.Precio AS Total
        FROM 
            Carrito c
        INNER JOIN 
            Productos p ON c.ProductoID = p.ProductoID
        WHERE 
            c.UsuarioID = @UsuarioID;

        -- Vacía el carrito después del pago
        DELETE FROM Carrito
        WHERE UsuarioID = @UsuarioID;

        -- Confirma la transacción
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, revierte la transacción
        ROLLBACK TRANSACTION;

        -- Lanza el error original
        THROW;
    END CATCH
END;

GO
/****** Object:  StoredProcedure [dbo].[CarritoVaciar]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CarritoVaciar]
    @UsuarioID INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM Carrito WHERE UsuarioID = @UsuarioID;
END;
GO
/****** Object:  StoredProcedure [dbo].[ClienteD]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ClienteD]
    @ClienteID int
AS
BEGIN
    UPDATE dbo.Clientes
    SET MembresiaActiva = 0
    WHERE ClienteID = @ClienteID
END;
GO
/****** Object:  StoredProcedure [dbo].[ClientesR]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ClientesR]
AS
BEGIN
    SELECT ClienteID,C.UsuarioID,U.Nombre,MembresiaActiva,FechaInicioMembresia,FechaFinMembresia
	    FROM dbo.Clientes C
	inner join dbo.Usuarios U on C.UsuarioID = U.UsuarioID
END;
GO
/****** Object:  StoredProcedure [dbo].[ConsultarCliente]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[ConsultarCliente]
    @ClienteID INT
AS
BEGIN
     SELECT ClienteID,C.UsuarioID,U.Nombre,MembresiaActiva,FechaInicioMembresia,FechaFinMembresia
	    FROM dbo.Clientes C
	inner join dbo.Usuarios U on C.UsuarioID = U.UsuarioID

    WHERE ClienteID = @ClienteID;
END;
GO
/****** Object:  StoredProcedure [dbo].[DeletePago]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeletePago]
    @PagoID INT
AS
BEGIN
    DELETE FROM Pagos WHERE PagoID = @PagoID;
	END;
GO
/****** Object:  StoredProcedure [dbo].[DeleteReserva]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteReserva]
    @ReservaID INT
AS
BEGIN
    DELETE FROM Reservas WHERE ReservaID = @ReservaID;
END;
GO
/****** Object:  StoredProcedure [dbo].[DeleteVenta]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteVenta]
    @VentaID INT
AS
BEGIN
    DELETE FROM Ventas WHERE VentaID = @VentaID;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetPagos]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[GetPagos]
AS
BEGIN
    SELECT u.Nombre AS UsuarioNombre, p.PagoID, p.UsuarioID, p.Monto, p.FechaPago, p.MetodoPago
           
    FROM Pagos p
    INNER JOIN Usuarios u ON p.UsuarioID = u.UsuarioID;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetReservas]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetReservas]
AS
BEGIN
    SELECT r.ReservaID, r.UsuarioID, r.FechaReserva, r.HoraInicio, r.HoraFin, r.Estado, r.MaquinaID, 
           u.Nombre AS UsuarioNombre, m.Nombre AS MaquinaNombre
    FROM Reservas r
    INNER JOIN Usuarios u ON r.UsuarioID = u.UsuarioID
    LEFT JOIN Maquinas m ON r.MaquinaID = m.MaquinaID;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetVentas]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetVentas]
AS
BEGIN
    SELECT v.VentaID, v.UsuarioID, v.ProductoID, v.Cantidad, v.FechaVenta, v.Total, 
           u.Nombre AS UsuarioNombre, p.NombreProducto AS ProductoNombre
    FROM Ventas v
    INNER JOIN Usuarios u ON v.UsuarioID = u.UsuarioID
    INNER JOIN Productos p ON v.ProductoID = p.ProductoID;
END;
GO
/****** Object:  StoredProcedure [dbo].[InicioSesion]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InicioSesion]
	@Email NVARCHAR(100),
    @Contrasena NVARCHAR(100)
AS
BEGIN
	SELECT UsuarioID, Nombre, Apellido, RolID
    FROM Usuarios
    WHERE Email = @Email 
	AND Contrasena = @Contrasena
	AND Activo = 1;
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertPago]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertPago]
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
/****** Object:  StoredProcedure [dbo].[InsertReserva]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[InsertReserva]
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
/****** Object:  StoredProcedure [dbo].[InsertVenta]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertVenta]
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
/****** Object:  StoredProcedure [dbo].[MaquinasC]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
----------------------------- Maquinas ----------------------------
CREATE procedure [dbo].[MaquinasC]
	@Nombre	varchar(100),
	@Descripcion	text,
	@Ubicacion	varchar(100)
AS
BEGIN
INSERT INTO Maquinas( Nombre, Descripcion, Ubicacion, Estado)
VALUES ( @Nombre, @Descripcion, @Ubicacion, 1);
	END;
GO
/****** Object:  StoredProcedure [dbo].[MaquinasR]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
CREATE PROCEDURE [dbo].[MaquinasR]   
AS
BEGIN
  SELECT[MaquinaID],[Nombre],[Descripcion],[Ubicacion],[Estado]
  FROM [NeonFitnessDB].[dbo].[Maquinas]  
END;
GO
/****** Object:  StoredProcedure [dbo].[MaquinasU]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
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
END;
GO
/****** Object:  StoredProcedure [dbo].[ModificarEmpleado]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ModificarEmpleado]
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
/****** Object:  StoredProcedure [dbo].[ModificarInstructor]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ModificarInstructor]
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
/****** Object:  StoredProcedure [dbo].[ObtenerEmpleadoPorID]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerEmpleadoPorID]
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
/****** Object:  StoredProcedure [dbo].[ObtenerEmpleados]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerEmpleados]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT e.EmpleadoID, e.UsuarioID, e.Puesto, e.FechaContratacion, 
           u.Nombre, u.Apellido, u.Email, u.Telefono
    FROM Empleados e
    INNER JOIN Usuarios u ON e.UsuarioID = u.UsuarioID;
END;
GO
/****** Object:  StoredProcedure [dbo].[ObtenerHistorialCompras]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ObtenerHistorialCompras]
    @UsuarioID INT
AS
BEGIN
    -- Selecciona los datos del historial de compras para el usuario dado
    SELECT 
        hc.CompraID,
        p.NombreProducto AS NombreProducto,
        hc.Cantidad,
        hc.Total,
        hc.FechaCompra
    FROM 
        HistorialCompras hc
    INNER JOIN 
        Productos p ON hc.ProductoID = p.ProductoID
    WHERE 
        hc.UsuarioID = @UsuarioID
    ORDER BY 
        hc.FechaCompra DESC;
END;

GO
/****** Object:  StoredProcedure [dbo].[ObtenerInstructores]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerInstructores]
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
/****** Object:  StoredProcedure [dbo].[ObtenerInstructoresConDetalle]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerInstructoresConDetalle]
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
        Usuarios u ON i.UsuarioID = u.UsuarioID;
END;
GO
/****** Object:  StoredProcedure [dbo].[ObtenerInstructorPorID]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerInstructorPorID]
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
/****** Object:  StoredProcedure [dbo].[ObtenerUsuariosParaEmpleados]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerUsuariosParaEmpleados]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT UsuarioID, Nombre, Apellido 
    FROM Usuarios 
    WHERE RolID = 4;
END;
GO
/****** Object:  StoredProcedure [dbo].[ObtenerUsuariosRol2]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerUsuariosRol2]
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
/****** Object:  StoredProcedure [dbo].[ProductoC]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProductoC]
	@NombreProducto NVARCHAR(100),
    @Descripcion NVARCHAR(255),
    @Precio DECIMAL(10, 2),
    @Stock INT,
	@Imagen NVARCHAR(50)
AS
BEGIN
    INSERT INTO Productos (NombreProducto, Descripcion, Precio, Stock, Imagen)
    VALUES (@NombreProducto, @Descripcion, @Precio, @Stock, @Imagen);

	DECLARE @ProductoId INT = SCOPE_IDENTITY();
END;
GO
/****** Object:  StoredProcedure [dbo].[ProductoD]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProductoD] ---- DELETE ----
    @ProductoID INT
AS
BEGIN
    DELETE FROM Productos WHERE ProductoID = @ProductoID;
	DELETE FROM Carrito WHERE ProductoID = @ProductoID;
	DELETE FROM Ventas WHERE ProductoID = @ProductoID;
END;
GO
/****** Object:  StoredProcedure [dbo].[ProductoR]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProductoR] ---- READ ---- 
    @ProductoID INT
AS
BEGIN
    SELECT ProductoID, NombreProducto, Descripcion, Precio, Stock
    FROM Productos
    WHERE ProductoID = @ProductoID;
END;
GO
/****** Object:  StoredProcedure [dbo].[ProductosCatalogo]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProductosCatalogo]
AS
BEGIN
    SELECT 
        ProductoID,
        NombreProducto,
        Descripcion,
        Precio,
        Stock,
        Imagen + CONVERT(VARCHAR,ProductoID) + '.png' Imagen
    FROM Productos
    WHERE Stock > 0;
END;
GO
/****** Object:  StoredProcedure [dbo].[ProductosLista]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProductosLista]
AS
BEGIN
    SELECT 
        ProductoID,
        NombreProducto,
        Descripcion,
        Precio,
        Stock
    FROM Productos;
END;
GO
/****** Object:  StoredProcedure [dbo].[ProductoU]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProductoU] ---- UPDATE ----
    @ProductoID INT,
    @NombreProducto NVARCHAR(50),
    @Descripcion NVARCHAR(50),
    @Precio NVARCHAR(100),
    @Stock NVARCHAR(100),
	@Imagen NVARCHAR(50)
AS
BEGIN
    UPDATE Productos
    SET NombreProducto = @NombreProducto,
        Descripcion = @Descripcion,
        Precio = @Precio,
        Stock = @Stock,
		Imagen = @Imagen
    WHERE ProductoID = @ProductoID;
END;
GO
/****** Object:  StoredProcedure [dbo].[RegistrarRecuperar]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[RegistrarRecuperar]
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

        SELECT UsuarioID, Nombre, Apellido, Email
        FROM Usuarios
        WHERE UsuarioID = @UsuarioID;

        RETURN 0;
    END
    ELSE
    BEGIN
        RETURN -1; 
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[RegistrarRestablecer]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[RegistrarRestablecer]
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
/****** Object:  StoredProcedure [dbo].[Registro]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------- SP LOGEO --------------------------

CREATE PROCEDURE [dbo].[Registro]
	@Nombre NVARCHAR(50),
	@Apellido NVARCHAR(50),
	@Email NVARCHAR(100),
	@Contrasena NVARCHAR(100),
	@Telefono NVARCHAR(20),
	@Direccion NVARCHAR(255),
	@RolID INT
AS
BEGIN
	INSERT INTO Usuarios (Nombre, Apellido, Email, Contrasena, Telefono, Direccion, FechaRegistro, RolID, Activo)
    VALUES (@Nombre, @Apellido, @Email, @Contrasena, @Telefono, @Direccion, GETDATE(), @RolID, 1);

	DECLARE @UsuarioId INT = SCOPE_IDENTITY();

    IF @RolID = 3
    BEGIN
        INSERT INTO [dbo].[Clientes] (UsuarioID, MembresiaActiva, FechaInicioMembresia, FechaFinMembresia)
        VALUES (@UsuarioId, 0, GETDATE(), NULL);
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[RolesLista]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------- SP ROLES --------------------------

CREATE PROCEDURE [dbo].[RolesLista]
AS
BEGIN
    SELECT RolID, NombreRol
    FROM Roles;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarEmpleado]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ActualizarEmpleado]
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
/****** Object:  StoredProcedure [dbo].[sp_ActualizarEstadoReserva]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ActualizarEstadoReserva]
    @ReservaID INT
AS
BEGIN
    UPDATE dbo.Reservas
    SET Estado = Case WHEN Estado = 1 THEN 0 Else 1 end
    WHERE ReservaID = @ReservaID;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarPago]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_EliminarPago]
    @PagoID INT
AS
BEGIN
    DELETE FROM Pagos WHERE PagoID = @PagoID;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarReserva]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_EliminarReserva]
    @ReservaID INT
AS
BEGIN
    DELETE FROM Reservas WHERE ReservaID = @ReservaID;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarVentas]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_EliminarVentas]
    @VentaID INT
AS
BEGIN
    DELETE FROM Ventas WHERE VentaID = @VentaID;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetEmpleados]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------- INGRESAR SP ConsultarMaquina -----------

----------------------------- Empleados e Instructores ----------------------------
CREATE PROCEDURE [dbo].[sp_GetEmpleados]
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
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarPago]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_InsertarPago]
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
/****** Object:  StoredProcedure [dbo].[sp_InsertarReserva]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_InsertarReserva]
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
/****** Object:  StoredProcedure [dbo].[sp_InsertarVenta]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_InsertarVenta]
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
/****** Object:  StoredProcedure [dbo].[sp_ObtenerPagos]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------  Pagos-----------------------------

Create PROCEDURE [dbo].[sp_ObtenerPagos]
AS
BEGIN
    SELECT u.Nombre AS UsuarioNombre, p.PagoID, p.UsuarioID, p.Monto, p.FechaPago, p.MetodoPago
           
    FROM Pagos p
    INNER JOIN Usuarios u ON p.UsuarioID = u.UsuarioID;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerProductos]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ObtenerProductos]
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
/****** Object:  StoredProcedure [dbo].[sp_ObtenerReservas]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-----------------------------  Reservas-----------------------------

CREATE PROCEDURE [dbo].[sp_ObtenerReservas]
AS
BEGIN
    SELECT r.ReservaID, r.UsuarioID, r.FechaReserva, r.HoraInicio, r.HoraFin, r.Estado, r.MaquinaID, 
           u.Nombre AS UsuarioNombre, m.Nombre AS MaquinaNombre
    FROM Reservas r
    INNER JOIN Usuarios u ON r.UsuarioID = u.UsuarioID
    LEFT JOIN Maquinas m ON r.MaquinaID = m.MaquinaID;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerVentas]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-----------------------------Ventas-----------------------------

CREATE PROCEDURE [dbo].[sp_ObtenerVentas]
AS
BEGIN
    SELECT v.VentaID, v.UsuarioID, v.ProductoID, v.Cantidad, v.FechaVenta, v.Total, 
           u.Nombre AS UsuarioNombre, p.NombreProducto AS ProductoNombre
    FROM Ventas v
    INNER JOIN Usuarios u ON v.UsuarioID = u.UsuarioID
    INNER JOIN Productos p ON v.ProductoID = p.ProductoID;
END;
GO
/****** Object:  StoredProcedure [dbo].[TokenC]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TokenC]
    @UsuarioID INT,
    @Token NVARCHAR(255),
    @FechaExpiracion DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO RecuperarTokens (UsuarioID, Token, FechaExpiracion)
    VALUES (@UsuarioID, @Token, @FechaExpiracion);
END;
GO
/****** Object:  StoredProcedure [dbo].[TokenD]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TokenD]
    @Token NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Eliminar el token
    DELETE FROM RecuperarTokens
    WHERE Token = @Token;

END;
GO
/****** Object:  StoredProcedure [dbo].[TokenRecuperacion]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TokenRecuperacion]
    @Email NVARCHAR(100),           -- Email del usuario que solicita recuperar contraseña
    @Token NVARCHAR(255),           -- Token generado
    @FechaExpiracion DATETIME       -- Fecha de expiración del token
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el email existe
    IF EXISTS (SELECT 1 FROM Usuarios WHERE Email = @Email)
    BEGIN
        -- Recuperar el UsuarioID asociado al email
        DECLARE @UsuarioID INT;
        SELECT @UsuarioID = UsuarioID FROM Usuarios WHERE Email = @Email;

        -- Insertar el token en la tabla RecuperarTokens
        INSERT INTO RecuperarTokens (UsuarioID, Token, FechaExpiracion)
        VALUES (@UsuarioID, @Token, @FechaExpiracion);

        RETURN 0; -- Operación exitosa
    END
    ELSE
    BEGIN
        RETURN -1; -- Email no encontrado
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[TokenValidar]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TokenValidar]
    @Token NVARCHAR(255)           -- Token proporcionado por el usuario
AS
BEGIN
    SET NOCOUNT ON;

    -- Devolver información del token si es válido
    SELECT 
        UsuarioID,
        FechaExpiracion
    FROM 
        RecuperarTokens
    WHERE 
        Token = @Token 
        AND FechaExpiracion > GETDATE();

    -- Si no se encuentra, retornar un conjunto vacío
END;

GO
/****** Object:  StoredProcedure [dbo].[UpdateEstadoReserva]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateEstadoReserva]
    @ReservaID INT,
    @Estado BIT
AS
BEGIN
    UPDATE Reservas
    SET Estado = @Estado
    WHERE ReservaID = @ReservaID;
END;
GO
/****** Object:  StoredProcedure [dbo].[UsuarioC]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
    INSERT INTO Usuarios (Nombre, Apellido, Email, Contrasena, Telefono, Direccion, FechaRegistro, RolID, Activo)
    VALUES (@Nombre, @Apellido, @Email, @Contrasena, @Telefono, @Direccion, GETDATE(), @RolID, 1);

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
/****** Object:  StoredProcedure [dbo].[UsuarioD]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UsuarioD]
    @UsuarioID INT
AS
BEGIN
	DELETE FROM RecuperarTokens WHERE UsuarioID = @UsuarioID;
    DELETE FROM Reservas WHERE UsuarioID = @UsuarioID;
	DELETE FROM Pagos WHERE UsuarioID = @UsuarioID;
    DELETE FROM Carrito WHERE UsuarioID = @UsuarioID;
	DELETE FROM Ventas WHERE UsuarioID = @UsuarioID;
	DELETE FROM Clientes WHERE UsuarioID = @UsuarioID;
    DELETE FROM Instructores WHERE UsuarioID = @UsuarioID;
	DELETE FROM Empleados WHERE UsuarioID = @UsuarioID;
	DELETE FROM Usuarios WHERE UsuarioID = @UsuarioID;
END;
GO
/****** Object:  StoredProcedure [dbo].[UsuarioR]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UsuarioR]
    @UsuarioID INT
AS
BEGIN
    SELECT UsuarioID, Nombre, Apellido, Email, Contrasena, Telefono, Direccion, FechaRegistro, RolID, Activo
    FROM Usuarios
    WHERE UsuarioID = @UsuarioID;
END;
GO
/****** Object:  StoredProcedure [dbo].[UsuariosInfo]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UsuariosInfo]
    @Email NVARCHAR(100),
	@Telefono NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        U.UsuarioID,
        U.Nombre,
        U.Email,
	U.Telefono,
        U.RolID,
        R.NombreRol
    FROM Usuarios U
    INNER JOIN Roles R ON U.RolID = R.RolID
    WHERE U.Email = @Email OR U.Telefono = @Telefono;
END;

GO
/****** Object:  StoredProcedure [dbo].[UsuariosLista]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UsuariosLista]
AS
BEGIN
    SELECT UsuarioID, Nombre, Apellido, Email, Telefono, Direccion, FechaRegistro, RolID, Activo
    FROM Usuarios;
END;
GO
/****** Object:  StoredProcedure [dbo].[UsuariosValidar]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UsuariosValidar]
    @Email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        U.UsuarioID,
        U.Nombre,
        U.Email,
	U.Telefono,
        U.RolID,
        R.NombreRol
    FROM Usuarios U
    INNER JOIN Roles R ON U.RolID = R.RolID
    WHERE U.Email = @Email;
END;

GO
/****** Object:  StoredProcedure [dbo].[UsuarioU]    Script Date: 12/21/2024 8:24:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
CREATE PROCEDURE [dbo].[UsuarioU]
    @UsuarioID INT,
    @Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
    @Email NVARCHAR(100),
    @Telefono NVARCHAR(20),
    @Direccion NVARCHAR(255),
    @RolID INT,
	@Activo BIT = 1
AS
BEGIN
    UPDATE Usuarios
    SET Nombre = @Nombre,
        Apellido = @Apellido,
        Email = @Email,
        Telefono = @Telefono,
        Direccion = @Direccion,
        RolID = @RolID,
		Activo = @Activo
    WHERE UsuarioID = @UsuarioID;

	IF @RolID = 3 -- Cliente
    BEGIN
		INSERT INTO [dbo].[Clientes] (UsuarioID, MembresiaActiva, FechaInicioMembresia, FechaFinMembresia)
		VALUES (@UsuarioId, 0, GETDATE(), NULL);
		 DELETE FROM Instructores WHERE UsuarioID = @UsuarioID;
		 DELETE FROM Empleados WHERE UsuarioID = @UsuarioID;
    END
	ELSE IF @RolID = 2 -- Instructor
    BEGIN
        INSERT INTO [dbo].[Instructores](UsuarioID, Especialidad, ExperienciaAnios)
		VALUES (@UsuarioId, NULL, NULL); 
	DELETE FROM Clientes WHERE UsuarioID = @UsuarioID;
     DELETE FROM Empleados WHERE UsuarioID = @UsuarioID;
    END
    ELSE IF @RolID = 4 -- Empleado
	BEGIN
        INSERT INTO [dbo].[Empleados] (UsuarioID, Puesto, FechaContratacion)
		VALUES (@UsuarioId, NULL, GETDATE());
	DELETE FROM Instructores WHERE UsuarioID = @UsuarioID;
	DELETE FROM Clientes WHERE UsuarioID = @UsuarioID;
	END;
END;
GO
USE [master]
GO
ALTER DATABASE [NeonFitnessDB] SET  READ_WRITE 
GO
