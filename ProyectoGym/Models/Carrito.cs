namespace ProyectoGym.Models
{
    public class Carrito
    {   
        public int CarritoId { get; set; }
        public int UsuarioID { get; set; }
        public int ProductoID { get; set; }
        public int Cantidad { get; set; }
        public DateTime FechaAgregado { get; set; }
    }
}
