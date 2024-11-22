namespace ProyectoGym.Models
{
    public class Instructores
    {
        public int InstructorID { get; set; }
        public int? UsuarioID { get; set; }
        public string Especialidad { get; set; }
        public int ExperienciaAnios { get; set; }
    }
}
