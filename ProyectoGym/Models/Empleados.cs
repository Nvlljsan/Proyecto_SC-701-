namespace ProyectoGym.Models
{
    public class Empleados
    {
        public int EmpleadoID { get; set; }
        public int UsuarioID { get; set; }
        public string Puesto { get; set; } = string.Empty;
        public DateTime FechaContratacion { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string Apellido { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Telefono { get; set; } = string.Empty;
        public string Direccion { get; set; } = string.Empty;
    }
}
