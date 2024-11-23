using Microsoft.AspNetCore.Mvc;
using ProyectoGym.Models;
using ProyectoGym.Services;
using System.Net.Http.Headers;
using System.Text.Json;

namespace ProyectoGym.Controllers
{
    public class MaquinasController : Controller
    {
            private readonly IHttpClientFactory _http;
            private readonly IConfiguration _conf;
            private readonly IMetodosComunes _comunes;

            public MaquinasController(IHttpClientFactory http, IConfiguration conf, IMetodosComunes comunes)
            {
                _http = http;
                _conf = conf;
                _comunes = comunes;
            }

        [HttpGet]
        public IActionResult MaquinasC()
        {
            return View();
        }

            [HttpPost]
            public IActionResult MaquinasC(Maquinas model)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Maquinas/MaquinasC";

               
                JsonContent datos = JsonContent.Create(model);

                var response = client.PostAsync(url, datos).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    return RedirectToAction("MaquinasLista", "Maquinas");
                }
                else
                {
                    ViewBag.Mensaje = result!.Mensaje;
                    return View();
                }
            }
        }

        [HttpGet]
        public IActionResult MaquinasLista()
        {
            
            using (var client = _http.CreateClient())
            {
                string url = _conf.GetSection("Variables:UrlApi").Value + "Maquinas/MaquinasLista";

                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", HttpContext.Session.GetString("TokenUsuario"));
                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    var datosContenido = JsonSerializer.Deserialize<List<Maquinas>>((JsonElement)result.Contenido!);
                    return View(datosContenido);
                }

                return View(new List<Maquinas>());
            }
        }
        [HttpGet]
        public IActionResult MaquinasU(int MaquinaID)
        {
            using (var client = _http.CreateClient())
            {

                string url = _conf.GetSection("Variables:UrlApi").Value + "Maquinas/ConsultarMaquinas?MaquinaID=" + MaquinaID;

                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", HttpContext.Session.GetString("TokenUsuario"));
                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    var datosContenido = JsonSerializer.Deserialize<Maquinas>((JsonElement)result.Contenido!);
                    return View(datosContenido);
                }

                return View(new Maquinas());
            }


        }

        [HttpPost]
        public IActionResult MaquinasU(Maquinas model)
        {


            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Maquinas/MaquinasU";

                JsonContent datos = JsonContent.Create(model);

                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", HttpContext.Session.GetString("TokenUsuario"));
                var response = client.PutAsync(url, datos).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;
                ViewBag.Mensaje = result!.Mensaje;

                if (result != null && result.Codigo == 0)
                {

                    return RedirectToAction("MaquinasLista", "Maquinas");

                }
                else
                {
                    return View();
                }
            }
        }




    }


}
