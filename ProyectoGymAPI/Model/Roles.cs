namespace ProyectoGymAPI.Model
{
    public class Roles
    {
        public int RolID { get; set; }
        public string NombreRol { get; set; }
        public virtual ICollection<Usuarios> Usuarios { get; set; } = new List<Usuarios>();
    }
}
