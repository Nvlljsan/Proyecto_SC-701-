using Microsoft.AspNetCore.Mvc;
using ProyectoGym.Models;
using System.Text.Json;

namespace ProyectoGym.Controllers
{
    public class UsuariosController : Controller
    {
        private readonly IHttpClientFactory _http;
        private readonly IConfiguration _conf;

        public UsuariosController(IHttpClientFactory http, IConfiguration conf)
        {
            _http = http;
            _conf = conf;
        }

        [HttpGet]
        public IActionResult UsuariosLista()
        {
            using (var client = _http.CreateClient())
            {
                string url = _conf.GetSection("Variables:UrlApi").Value + "Usuarios/UsuariosLista";

                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    var datosContenido = JsonSerializer.Deserialize<List<Usuarios>>((JsonElement)result.Contenido!);
                    return View(datosContenido);
                }

                return View(new List<Usuarios>());
            }
        }


        [HttpGet]
        public IActionResult UsuarioC()
        {
            return View();
        }

        [HttpPost]
        public IActionResult UsuarioC(Usuarios model)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Usuarios/UsuarioC";

                JsonContent datos = JsonContent.Create(model);

                var response = client.PostAsync(url, datos).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    return RedirectToAction("UsuariosLista", "Usuarios");
                }
                else
                {
                    ViewBag.Mensaje = result!.Mensaje;
                    return View();
                }
            }
        }
    }
}
