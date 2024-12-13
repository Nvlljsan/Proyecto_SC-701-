using Microsoft.AspNetCore.Mvc;
using ProyectoGym.Models;
using System.Security.Claims;
using System.Text.Json;

namespace ProyectoGym.Controllers
{
    public class CarritoController : Controller
    {
        private readonly IHttpClientFactory _http;
        private readonly IConfiguration _conf;

        public CarritoController(IHttpClientFactory http, IConfiguration conf)
        {
            _http = http;
            _conf = conf;
        }

        [HttpGet]
        public IActionResult CarritoLista()
        {
            var usuarioIDClaim = User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value;

            int usuarioID = int.Parse(usuarioIDClaim);

            List<Carrito> carrito = new List<Carrito>();

            //=========================[Especificar el Usuario y hacer una nueva lista por sesión]=========================

            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + $"Carrito/ObtenerCarrito/{usuarioID}";

                var response = client.GetAsync(url).Result;

                if (response.IsSuccessStatusCode)
                {
                    carrito = response.Content.ReadFromJsonAsync<List<Carrito>>().Result;
                }
                else
                {
                    return View("Inicio", "Home");
                }
            }

            return View(carrito);
        }


        [HttpPost]
        public IActionResult AgregarAlCarrito(int productoID, int cantidad)
        {
            var usuarioIDClaim = User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value;

            int usuarioID = int.Parse(usuarioIDClaim);

            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Carrito/AgregarAlCarrito";

                var monto = new { usuarioID, productoID, cantidad };

                JsonContent datos = JsonContent.Create(monto);
                var response = client.PostAsync(url, datos).Result;

                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    return RedirectToAction("CarritoLista", "Carrito");
                }

                TempData["Error"] = result?.Mensaje ?? "Error desconocido al agregar el producto.";
                return RedirectToAction("Inicio", "Home");
            }
        }






        // Eliminar un producto del carrito
        [HttpPost]
        public IActionResult Eliminar(int carritoID, int usuarioID)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + $"Carrito/EliminarProducto?carritoID={carritoID}";

                var response = client.DeleteAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    return RedirectToAction("Index", new { usuarioID });
                }

                ViewBag.Mensaje = result?.Mensaje ?? "Error al eliminar el producto del carrito.";
                return RedirectToAction("Index", new { usuarioID });
            }
        }
    }
}
