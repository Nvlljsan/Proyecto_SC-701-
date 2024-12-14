namespace ProyectoGym.Models
{
    public class Productos
    {
        public int ProductoID { get; set; }
        public string NombreProducto { get; set; } = string.Empty;
        public string Descripcion { get; set; } = string.Empty;
        public decimal Precio { get; set; }
        public int Stock { get; set; }
        public string Imagen { get; set; } = string.Empty;
    }
}
