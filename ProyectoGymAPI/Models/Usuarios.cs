namespace ProyectoGymAPI.Models
{
    public class Usuarios
    {
        public int UsuarioID { get; set; } 
        public string Nombre { get; set; } = string.Empty;
        public string Apellido { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Contrasena { get; set; } = string.Empty;
        public string Telefono { get; set; } = string.Empty;
        public string Direccion { get; set; } = string.Empty;
        public DateTime FechaRegistro { get; set; }
        public int? RolID { get; set; }
        public bool Activo { get; set; }
        public string NombreRol { get; set; } = string.Empty;

    }
}
