namespace ProyectoGymAPI.Model
{
    public class Productos
    {
        public int ProductoID { get; set; }
        public string NombreProducto { get; set; }
        public string Descripcion { get; set; }
        public decimal Precio { get; set; }
        public int Stock { get; set; }
        public ICollection<Ventas> Ventas { get; set; } = new List<Ventas>();
    }
}
