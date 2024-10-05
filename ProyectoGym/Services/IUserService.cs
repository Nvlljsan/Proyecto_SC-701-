using Microsoft.AspNetCore.Mvc;

namespace ProyectoGym.Services
{
    public class IUserService : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
