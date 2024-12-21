namespace ProyectoGymAPI.Models
{
    public class HistorialCompraViewModel
    {
        public int CompraID { get; set; }
        public string NombreProducto { get; set; }
        public int Cantidad { get; set; }
        public decimal Total { get; set; }
        public DateTime FechaCompra { get; set; }
    }

}
