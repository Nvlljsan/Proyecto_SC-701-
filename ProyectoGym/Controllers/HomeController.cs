using Microsoft.AspNetCore.Mvc;
using ProyectoGym.Models;
using System.Diagnostics;

namespace ProyectoGym.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Inicio()
        {
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

      
    }
}
