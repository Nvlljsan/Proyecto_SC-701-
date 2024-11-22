namespace ProyectoGym.Models
{
    public class ReservasViewModel
    {
        public int ReservaID { get; set; }
        public int UsuarioID { get; set; }
        public string UsuarioNombre { get; set; } // Nombre del usuario que realiza la reserva
        public DateTime FechaReserva { get; set; }
        public TimeSpan HoraInicio { get; set; }
        public TimeSpan HoraFin { get; set; }
        public bool Estado { get; set; } // True: Activa, False: Cancelada
        public int? MaquinaID { get; set; }
        public string MaquinaNombre { get; set; } // Nombre de la máquina reservada
    }
}