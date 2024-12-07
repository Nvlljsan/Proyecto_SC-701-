namespace ProyectoGymAPI.Models.Requests
{
    public class CarritoRequest
    {
        public int UsuarioID { get; set; }
        public int ProductoID { get; set; }
        public int Cantidad { get; set; }
    }
}
