using Microsoft.AspNetCore.Mvc;
using ProyectoGym.Models;
using ProyectoGym.Services;
using System.Net.Http.Headers;
using System.Text.Json;

namespace ProyectoGym.Controllers
{
    public class ProductosController : Controller
    {
        private readonly IHttpClientFactory _http;
        private readonly IConfiguration _conf;
        private readonly IMetodosComunes _comunes;

        public ProductosController(IHttpClientFactory http, IConfiguration conf, IMetodosComunes comunes)
        {
            _http = http;
            _conf = conf;
            _comunes = comunes;
        }

        [HttpGet]
        public IActionResult ProductosLista()
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Productos/ProductosLista";

                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    var datosContenido = JsonSerializer.Deserialize<List<Productos>>((JsonElement)result.Contenido!);
                    return View(datosContenido);
                }

                return View(new List<Productos>());
            }
        }

        [HttpGet]
        public IActionResult ProductoC()
        {
            return View();
        }

        [HttpPost]
        public IActionResult ProductoC(Productos model)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Productos/ProductoC";

                JsonContent datos = JsonContent.Create(model);

                var response = client.PostAsync(url, datos).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    return RedirectToAction("ProductosLista", "Productos");
                }
                else
                {
                    ViewBag.Mensaje = result!.Mensaje;
                    return View();
                }
            }
        }

        [HttpGet]
        public IActionResult ProductoU(int ProductoID)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + $"Productos/ProductoR?productoID={ProductoID}";

                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Productos>().Result;

                if (result != null)
                {
                    return View(result);
                }
                else
                {
                    ViewBag.Mensaje = "No se encontraron datos del producto.";
                    return RedirectToAction("ProductosLista");
                }
            }
        }

        [HttpPost]
        public IActionResult ProductoU(Productos model)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Productos/ProductoU";

                JsonContent datos = JsonContent.Create(model);

                var response = client.PutAsync(url, datos).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    return RedirectToAction("ProductosLista");
                }
                else
                {
                    ViewBag.Mensaje = result!.Mensaje;
                    return View(model);
                }
            }
        }

        [HttpPost]
        public IActionResult ProductoD(int productoID)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Productos/ProductoD?productoID=" + productoID;

                var response = client.DeleteAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    return RedirectToAction("ProductosLista");
                }
                else
                {
                    ViewBag.Mensaje = result?.Mensaje ?? "Error desconocido";
                    return RedirectToAction("ProductosLista");
                }
            }
        }

        [HttpGet]
        public IActionResult CatalogoProductos()
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Productos/ProductosLista";

                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    var datosContenido = JsonSerializer.Deserialize<List<Productos>>((JsonElement)result.Contenido!);
                    return View(datosContenido);
                }

                return View(new List<Productos>());
            }
        }
    }
}
