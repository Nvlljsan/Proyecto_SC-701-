using Microsoft.AspNetCore.Mvc;
using ProyectoGym.Models;
using ProyectoGym.Services;

namespace ProyectoGym.Controllers
{
    public class AccountController : Controller
    {
        private readonly IUserService _userService;

        public AccountController(IUserService userService)
        {
            _userService = userService;
        }

        public IActionResult Register()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Register(RegisterViewModel model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    _userService.RegisterUser(model);
                    ViewBag.SuccessMessage = "Usuario registrado exitosamente.";
                    return View();
                }
                catch (Exception ex)
                {
                    ViewBag.ErrorMessage = "Error al registrar el usuario: " + ex.Message;
                }
            }

            return View(model);
        }
    }
}
