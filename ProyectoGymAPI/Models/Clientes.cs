namespace ProyectoGymAPI.Models
{
    public class Clientes
    {
        public int ClienteID { get; set; }
        public int? UsuarioID { get; set; }  
        public string Nombre { get; set; } = string.Empty;
        public bool MembresiaActiva { get; set; }
      
        public DateTime? FechaInicioMembresia { get; set; }
        public DateTime? FechaFinMembresia { get; set; }
    }
}
