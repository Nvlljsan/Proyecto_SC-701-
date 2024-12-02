using System.ComponentModel.DataAnnotations;

namespace ProyectoGym.Models.ViewModels
{
    public class RecuperarContrasenaVM
    {
        [Required(ErrorMessage = "El correo es obligatorio.")]
        [EmailAddress(ErrorMessage = "Debe ingresar un correo válido.")]
        public string Email { get; set; }
    }
}
