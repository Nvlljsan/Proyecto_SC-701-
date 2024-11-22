namespace ProyectoGymAPI.Model
{
    public class Ventas
    {
            public int VentaID { get; set; } 
            public int? UsuarioID { get; set; } 
            public int? ProductoID { get; set; } 
            public int Cantidad { get; set; } 
            public DateTime FechaVenta { get; set; } 
            public decimal Total { get; set; } 
    }
}
