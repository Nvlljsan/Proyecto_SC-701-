namespace ProyectoGym.Models
{
    public class InstructorViewModel
    {
        public Instructores Instructor { get; set; } = new Instructores();
        public List<Usuarios> UsuariosDisponibles { get; set; } = new List<Usuarios>();
    }
}
