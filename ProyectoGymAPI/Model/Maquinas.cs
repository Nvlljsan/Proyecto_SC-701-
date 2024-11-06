namespace ProyectoGymAPI.Model
{
    public class Maquinas
    {
        public int MaquinaID { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public string Ubicacion { get; set; }
        public bool Estado { get; set; }
        public ICollection<Reservas> Reservas { get; set; } = new List<Reservas>();
        public ICollection<MantenimientoMaquinas> Mantenimientos { get; set; } = new List<MantenimientoMaquinas>();
    }
}
