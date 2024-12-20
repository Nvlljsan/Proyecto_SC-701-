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
        public async Task<IActionResult> AgregarAlCarrito(int productoID, int cantidad)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Carrito/AgregarAlCarrito";

                var model = new Carrito
                {
                    UsuarioID = int.Parse(User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value),
                    ProductoID = productoID,
                    Cantidad = cantidad,
                    FechaAgregado = DateTime.Now
                };

                JsonContent datos = JsonContent.Create(model);

                var response = await client.PostAsync(url, datos);
                var result = await response.Content.ReadFromJsonAsync<Respuesta>();

                return Json(result?.Codigo ?? -1);

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
