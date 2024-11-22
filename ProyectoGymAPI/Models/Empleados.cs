namespace ProyectoGymAPI.Models
{
    public class Empleados
    {
        public int EmpleadoID { get; set; }
        public int? UsuarioID { get; set; }
        public string Puesto { get; set; }
        public DateTime FechaContratacion { get; set; }
    }
}
