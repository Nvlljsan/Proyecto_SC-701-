namespace ProyectoGymAPI.Models
{
    public class Maquinas
    {
        public int MaquinaID { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string Descripcion { get; set; } = string.Empty;
        public string Ubicacion { get; set; } = string.Empty;
        public bool Estado { get; set; }
        public ICollection<Reservas> Reservas { get; set; } = new List<Reservas>();
        public ICollection<MantenimientoMaquinas> Mantenimientos { get; set; } = new List<MantenimientoMaquinas>();
    }
}
