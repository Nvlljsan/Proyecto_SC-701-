
namespace ProyectoGym.Models
{
    public class Instructores
    {
        public int InstructorID { get; set; }
        public int UsuarioID { get; set; }
        public string Especialidad { get; set; } = string.Empty;
        public int ExperienciaAnios { get; set; }

        public string Nombre { get; set; } = string.Empty;
        public string Apellido { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Telefono { get; set; } = string.Empty;
    }
}
