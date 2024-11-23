namespace ProyectoGym.Models
{
    public class Maquinas
    {
        public int MaquinaID { get; set; }
        public string Nombre { get; set; }=string.Empty;
        public string Descripcion { get; set; } = string.Empty;
        public string Ubicacion { get; set; } = string.Empty;
        public bool Estado { get; set; }
    }
}
