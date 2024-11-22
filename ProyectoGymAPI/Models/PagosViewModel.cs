namespace ProyectoGymAPI.Models
{
    public class PagosViewModel

    {
        public int PagoID { get; set; }
        public string UsuarioNombre { get; set; }
        public decimal Monto { get; set; }
        public DateTime FechaPago { get; set; }
        public string MetodoPago { get; set; }
    }
}