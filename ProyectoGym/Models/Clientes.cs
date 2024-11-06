namespace ProyectoGym.Model
{
    public class Clientes
    {
        public int ClienteID { get; set; }
        public int? UsuarioID { get; set; }
        public bool MembresiaActiva { get; set; }
        public DateTime? FechaInicioMembresia { get; set; }
        public DateTime? FechaFinMembresia { get; set; }
    }
}
