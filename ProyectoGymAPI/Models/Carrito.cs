namespace ProyectoGymAPI.Models
{
    public class Carrito
    {
        public int CarritoID { get; set; }
        public int ProductoID { get; set; }
        public string NombreProducto { get; set; }
        public decimal Precio { get; set; }
        public int Cantidad { get; set; }
        public decimal Subtotal { get; set; }
    }
}
