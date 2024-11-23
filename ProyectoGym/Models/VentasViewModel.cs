namespace ProyectoGym.Models
{
    public class VentasViewModel
    {

        public int VentaID { get; set; }
        public int? UsuarioID { get; set; }
        public int? ProductoID { get; set; }

        public string UsuarioNombre { get; set; }
        public string ProductoNombre { get; set; }
        public int Cantidad { get; set; }
        public DateTime FechaVenta { get; set; }
        public decimal Total { get; set; }
    }
}