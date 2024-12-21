using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using ProyectoGym.Models;
using ProyectoGym.Models.ViewModels;
using ProyectoGym.Services;
using System.Data.Common;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text.Json;

namespace ProyectoGym.Controllers
{
    public class CarritoController : Controller
    {
        private readonly IHttpClientFactory _http;
        private readonly IConfiguration _conf;
        private readonly IMetodosComunes _comunes;

        public CarritoController(IHttpClientFactory http, IConfiguration conf, IMetodosComunes comunes)
        {
            _http = http;
            _conf = conf;
            _comunes = comunes;
        }

        [HttpGet]

        public IActionResult CarritoLista()
        {
            return View(_comunes.CarritoLista());
        }

        [HttpGet]
        public async Task<IActionResult> HistorialCompras()
        {
            // Obtén el ID del usuario desde los claims
            var usuarioID = int.Parse(User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value);

            // Configura la URL de la API
            var url = $"{_conf.GetSection("Variables:UrlApi").Value}Carrito/HistorialCompras/{usuarioID}";

            using (var client = _http.CreateClient())
            {
                var response = await client.GetAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    // Deserializa la respuesta en una lista de HistorialCompraViewModel
                    var historial = await response.Content.ReadFromJsonAsync<List<HistorialCompraViewModel>>();
                    return View(historial);
                }

                ViewBag.Mensaje = "No se pudo cargar el historial de compras.";
                return View(new List<HistorialCompraViewModel>());
            }
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
public IActionResult Eliminar(int carritoID, int usuarioID)
{
    using (var client = _http.CreateClient())
    {
        var url = $"{_conf.GetSection("Variables:UrlApi").Value}Carrito/EliminarProducto?carritoID={carritoID}";
        var response = client.DeleteAsync(url).Result;

        if (response.IsSuccessStatusCode)
        {
            return RedirectToAction("CarritoLista", new { usuarioID });
        }

        var responseContent = response.Content.ReadAsStringAsync().Result;

        if (!string.IsNullOrWhiteSpace(responseContent))
        {
            var result = JsonSerializer.Deserialize<Respuesta>(responseContent, new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });

            ViewBag.Mensaje = result?.Mensaje ?? "Error al eliminar el producto del carrito.";
        }
        else
        {
            ViewBag.Mensaje = "La API devolvió una respuesta vacía.";
        }

        return RedirectToAction("CarritoLista", new { usuarioID });
    }
}

        [HttpPost]
        public async Task<IActionResult> SimularPago()
        {
            using (var client = _http.CreateClient())
            {
                var usuarioID = int.Parse(User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value);

                var url = $"{_conf.GetSection("Variables:UrlApi").Value}Carrito/SimularPago";

                // Usa el modelo existente
                var usuario = new Usuarios { UsuarioID = usuarioID };

                Console.WriteLine($"Datos enviados a la API: {JsonSerializer.Serialize(usuario)}");

                var response = await client.PostAsJsonAsync(url, usuario);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<Respuesta>();
                    ViewBag.Mensaje = result?.Mensaje ?? "Pago realizado correctamente.";
                    return RedirectToAction("HistorialCompras");
                }

                var errorContent = await response.Content.ReadAsStringAsync();
                Console.WriteLine($"Error al procesar el pago: {errorContent}");
                ViewBag.Mensaje = "Error al procesar el pago.";
                return RedirectToAction("CarritoLista");
            }
        }


    }

}

