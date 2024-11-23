-----------------------------Stored Procedures ----------------------------
USE NeonFitnessDB
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











