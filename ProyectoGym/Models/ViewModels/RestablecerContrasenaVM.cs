using System.ComponentModel.DataAnnotations;

namespace ProyectoGym.Models.ViewModels
{
    public class RestablecerContrasenaVM
    {
        [Required]
        public string Token { get; set; }

        [Required(ErrorMessage = "Debe ingresar una nueva contraseña.")]
        [MinLength(6, ErrorMessage = "La contraseña debe tener al menos 6 caracteres.")]
        public string NuevaContrasena { get; set; }
    }

}
