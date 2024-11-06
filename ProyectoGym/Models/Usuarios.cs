namespace ProyectoGym.Model
{
    public class Usuarios
    {
        public int UsuarioID { get; set; } 
        public string Nombre { get; set; } 
        public string Apellido { get; set; } 
        public string Email { get; set; } 
        public string Contrasena { get; set; } 
        public string Telefono { get; set; } 
        public string Direccion { get; set; } 
        public DateTime FechaRegistro { get; set; }
        public int? RolID { get; set; }
        public virtual ICollection<Ventas> Ventas { get; set; } = new List<Ventas>();
        public virtual ICollection<Reservas> Reservas { get; set; } = new List<Reservas>();
    }
}
