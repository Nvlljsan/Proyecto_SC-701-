namespace ProyectoGymAPI.Models
{
    public class Pagos
    {
        public int PagoID { get; set; }
        public int? UsuarioID { get; set; }
        public decimal Monto { get; set; }
        public DateTime FechaPago { get; set; }
        public string MetodoPago { get; set; }
    }
}
