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

        [HttpPost]
        public IActionResult AgregarAlCarrito(int productoID, int cantidad) //FUNCIONA PERO RECIBE EL -1 DEL API
        {

            using (var client = _http.CreateClient())
            {

                var url = _conf.GetSection("Variables:UrlApi").Value + "Carrito/AgregarAlCarrito";

                var model = new Carrito();
                model.UsuarioID = int.Parse(User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value);
                model.ProductoID = productoID;
                model.Cantidad = cantidad;
                model.FechaAgregado = DateTime.Now;

                foreach (var claim in User.Claims)
                {
                    Console.WriteLine($"Claim Type: {claim.Type}, Claim Value: {claim.Value}");
                }

                JsonContent datos = JsonContent.Create(model);

                var response = client.PostAsync(url, datos).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                return Json(result!.Codigo);
            }
        }

        [HttpPost]
        public IActionResult Eliminar(int carritoID, int usuarioID) //HAY QUE HACER UNA VIEW
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
