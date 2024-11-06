namespace ProyectoGym.Model
{
    public class MantenimientoMaquinas
    {
        public int MantenimientoID { get; set; }
        public int? EmpleadoID { get; set; }
        public int? MaquinaID { get; set; }
        public DateTime FechaMantenimiento { get; set; }
        public string Descripcion { get; set; }
    }
}
