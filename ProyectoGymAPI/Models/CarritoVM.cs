namespace ProyectoGymAPI.Models
{
    public class CarritoViewModel
    {
        public int UsuarioID { get; set; }
        public int CarritoID { get; set; }
        public int ProductoID { get; set; }
        public string NombreProducto { get; set; }
        public string Descripcion { get; set; }
        public int Cantidad { get; set; }
        public decimal Precio { get; set; }
        public decimal Subtotal => Cantidad * Precio; // Cálculo automático
        public DateTime FechaAgregado { get; set; }
    }

}
