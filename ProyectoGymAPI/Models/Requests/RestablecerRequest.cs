namespace ProyectoGymAPI.Models.Requests
{
    public class RestablecerRequest
    {
        public string Token { get; set; }
        public string NuevaContrasena { get; set; }
    }
}
