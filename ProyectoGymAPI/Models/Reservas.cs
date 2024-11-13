namespace ProyectoGymAPI.Models
{
    public class Reservas
    {
        public int ReservaID { get; set; } 
        public int? UsuarioID { get; set; } 
        public DateTime FechaReserva { get; set; } 
        public TimeSpan HoraInicio { get; set; } 
        public TimeSpan HoraFin { get; set; } 
        public bool Estado { get; set; } 
        public int? MaquinaID { get; set; } 
    }
}
