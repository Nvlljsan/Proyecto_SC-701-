using Microsoft.AspNetCore.Mvc;

namespace ProyectoGym.Models
{
    public class ApplicationUser : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
