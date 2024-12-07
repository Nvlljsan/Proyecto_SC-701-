using Microsoft.AspNetCore.Mvc;
using ProyectoGym.Models;
using System.Net.Http;
using System.Text.Json;

namespace ProyectoGym.Controllers
{
    public class InstructoresController : Controller
    {
        private readonly IHttpClientFactory _http;
        private readonly IConfiguration _conf;

        public InstructoresController(IHttpClientFactory http, IConfiguration conf)
        {
            _http = http;
            _conf = conf;
        }

        [HttpGet]
        public async Task<IActionResult> VistaInstructores()
        {
            List<Instructores> instructores = new List<Instructores>();
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Instructores/ObtenerInstructoresConDetalle";
                var response = await client.GetAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<Respuesta>();
                    if (result != null && result.Codigo == 0 && result.Contenido != null)
                    {
                        instructores = JsonSerializer.Deserialize<List<Instructores>>((JsonElement)result.Contenido!)!;
                    }
                    else
                    {
                        ViewBag.Mensaje = result?.Mensaje ?? "Error desconocido.";
                    }
                }
                else
                {
                    ViewBag.Mensaje = $"Error al consultar instructores. Status: {response.StatusCode}";
                }
            }

            return View(instructores);
        }



        [HttpGet]
        public async Task<IActionResult> ModificarInstructor(int id)
        {
            Instructores instructor = new Instructores();
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Instructores/ObtenerInstructorPorID?id=" + id;
                var response = await client.GetAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<Respuesta>();
                    if (result != null && result.Codigo == 0 && result.Contenido != null)
                    {
                        instructor = JsonSerializer.Deserialize<Instructores>((JsonElement)result.Contenido!)!;
                    }
                }
                else
                {
                    ViewBag.Mensaje = "Error al consultar el instructor.";
                }
            }

            return View(instructor);
        }


        [HttpPost]
        public async Task<IActionResult> ModificarInstructor(Instructores model)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Instructores/ModificarInstructor";
                var response = await client.PutAsJsonAsync(url, model);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<Respuesta>();
                    if (result != null && result.Codigo == 0)
                    {
                        TempData["Mensaje"] = "Instructor modificado correctamente.";
                        return RedirectToAction("VistaInstructores");
                    }
                    else
                    {
                        ViewBag.Mensaje = result?.Mensaje ?? "Error desconocido en la respuesta.";
                    }
                }
                else
                {
                    ViewBag.Mensaje = $"Error al conectar con el API. Status: {response.StatusCode}";
                }
            }

            return View(model);
        }

        [HttpGet]
        public async Task<IActionResult> AgregarInstructor()
        {
            List<Usuarios> usuarios = new List<Usuarios>();
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Instructores/ObtenerUsuariosRol2";
                var response = await client.GetAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<Respuesta>();
                    if (result != null && result.Codigo == 0 && result.Contenido != null)
                    {
                        usuarios = JsonSerializer.Deserialize<List<Usuarios>>((JsonElement)result.Contenido!)!;
                    }
                    else
                    {
                        ViewBag.Mensaje = result?.Mensaje ?? "Error desconocido.";
                    }
                }
                else
                {
                    ViewBag.Mensaje = $"Error al consultar usuarios. Status: {response.StatusCode}";
                }
            }

            ViewBag.Usuarios = usuarios;
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> AgregarInstructor(Instructores model)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Instructores/AgregarInstructor";
                var response = await client.PostAsJsonAsync(url, model);

                if (response.IsSuccessStatusCode)
                {
                    TempData["Mensaje"] = "Instructor agregado correctamente.";
                    return RedirectToAction("VistaInstructores");
                }
                else
                {
                    ViewBag.Mensaje = "Error al agregar el instructor.";
                    return View(model);
                }
            }
        }

    }
}
