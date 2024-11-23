using Microsoft.AspNetCore.Mvc;
using ProyectoGym.Models;
using ProyectoGym.Services;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text.Json;

namespace ProyectoGym.Controllers
{
    public class ClientesController : Controller
    {

        private readonly IHttpClientFactory _http;
        private readonly IConfiguration _conf;
        private readonly IMetodosComunes _comunes;

        public ClientesController(IHttpClientFactory http, IConfiguration conf, IMetodosComunes comunes)
        {
            _http = http;
            _conf = conf;
            _comunes = comunes;
        }

        [HttpGet]
        public IActionResult ClientesLista()
        {
           ;
            var consecutivo = long.Parse(@User.FindFirstValue(ClaimTypes.NameIdentifier)!.ToString());


            using (var client = _http.CreateClient())
            {
                string url = _conf.GetSection("Variables:UrlApi").Value + "Clientes/ClientesLista";

                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", HttpContext.Session.GetString("TokenUsuario"));
                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    var datosContenido = JsonSerializer.Deserialize<List<Clientes>>((JsonElement)result.Contenido!);
                    return View(datosContenido!.Where(x => x.ClienteID != consecutivo).ToList());
                }

                return View(new List<Clientes>());
            }
        }


        [HttpGet]
        public IActionResult ClienteU(int ClienteID)
        {
            using (var client = _http.CreateClient())
            {
               
                string url = _conf.GetSection("Variables:UrlApi").Value + "Clientes/ConsultarCliente?ClienteID=" + ClienteID;

                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", HttpContext.Session.GetString("TokenUsuario"));
                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    var datosContenido = JsonSerializer.Deserialize<Clientes>((JsonElement)result.Contenido!);
                    return View(datosContenido);
                }

                return View(new Clientes());
            }


        }

        [HttpPost]
        public IActionResult ClienteU(Clientes model)
        {
           

            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Clientes/ActualizarCliente";

                JsonContent datos = JsonContent.Create(model);

                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", HttpContext.Session.GetString("TokenUsuario"));
                var response = client.PutAsync(url, datos).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;
                ViewBag.Mensaje = result!.Mensaje;

                if (result != null && result.Codigo == 0)
                {

                    return RedirectToAction("ClientesLista", "Clientes");
                
            }
                else
                {
                    return View();
                }
            }
        }

        [HttpGet]
        public IActionResult ClienteInactivo(int ClienteID)
        {
            using (var client = _http.CreateClient())
            {
                string url = _conf.GetSection("Variables:UrlApi").Value + "Clientes/ClienteInactivo?ClienteID=" + ClienteID;


                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", HttpContext.Session.GetString("TokenUsuario"));
                var response = client.DeleteAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;



                return RedirectToAction("ClientesLista", "Clientes");
            }
        }
        }

    }
