namespace ProyectoGymAPI.Model
{
    public class Empleados
    {
        public int EmpleadoID { get; set; }
        public int UsuarioID { get; set; }
        public string Puesto { get; set; }
        public DateTime FechaContratacion { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string Email { get; set; }
        public string Telefono { get; set; }
        public string Direccion { get; set; }
    }
}
