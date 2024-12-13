namespace ProyectoGym.Models.ViewModels
{
    public class CarritoViewModel
    {
        public int ProductoID { get; set; }
        public string NombreProducto { get; set; }
        public string Descripcion { get; set; }
        public int Cantidad { get; set; }
        public decimal Precio { get; set; }
        public decimal Subtotal => Cantidad * Precio; // Cálculo automático
        public DateTime FechaAgregado { get; set; }
    }

}
