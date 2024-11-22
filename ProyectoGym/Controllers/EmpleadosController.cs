using Microsoft.AspNetCore.Mvc;
using ProyectoGym.Model;
using ProyectoGym.Models;
using System.Text.Json;

namespace ProyectoGym.Controllers
{
    public class EmpleadosController : Controller
    {
        private readonly IHttpClientFactory _http;
        private readonly IConfiguration _conf;

        public EmpleadosController(IHttpClientFactory http, IConfiguration conf)
        {
            _http = http;
            _conf = conf;
        }

        [HttpGet]
        public IActionResult VistaEmpleados()
        {
            List<Empleados> empleados = new List<Empleados>();

            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Empleados";
                var response = client.GetAsync(url).Result;

                if (response.IsSuccessStatusCode)
                {
                    empleados = response.Content.ReadFromJsonAsync<List<Empleados>>().Result ?? new List<Empleados>();
                }
                else
                {
                    ViewBag.Mensaje = "Error al conectar con el API.";
                }
            }

            return View(empleados);
        }

        [HttpGet]
        public async Task<IActionResult> AgregarEmpleado()
        {
            List<Usuarios> usuarios = new List<Usuarios>();
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Empleados/ObtenerUsuariosParaEmpleados";
                var response = await client.GetAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<Respuesta>();
                    if (result != null && result.Codigo == 0 && result.Contenido != null)
                    {
                        usuarios = JsonSerializer.Deserialize<List<Usuarios>>((JsonElement)result.Contenido!)!;
                    }
                }
                else
                {
                    ViewBag.Mensaje = "Error al consultar usuarios.";
                }
            }

            ViewBag.Usuarios = usuarios;
            return View();
        }


        [HttpPost]
        public async Task<IActionResult> AgregarEmpleado(Empleados model)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Empleados/AgregarEmpleado";
                var response = await client.PostAsJsonAsync(url, model);

                if (response.IsSuccessStatusCode)
                {
                    TempData["Mensaje"] = "Empleado agregado correctamente.";
                    return RedirectToAction("VistaEmpleados");
                }
                else
                {
                    ViewBag.Mensaje = "Error al agregar empleado.";
                    return View(model);
                }
            }
        }

        [HttpGet]
        public async Task<IActionResult> ModificarEmpleado(int id)
        {
            Empleados empleado = new Empleados();
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Empleados/ObtenerEmpleadoPorID?id=" + id;
                var response = await client.GetAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<Respuesta>();
                    if (result != null && result.Codigo == 0 && result.Contenido != null)
                    {
                        empleado = JsonSerializer.Deserialize<Empleados>((JsonElement)result.Contenido!)!;
                    }
                    else
                    {
                        ViewBag.Mensaje = result?.Mensaje ?? "No se encontró el empleado.";
                        return RedirectToAction("VistaEmpleados");
                    }
                }
                else
                {
                    ViewBag.Mensaje = $"Error al consultar empleado. Status: {response.StatusCode}";
                    return RedirectToAction("VistaEmpleados");
                }
            }

            return View(empleado);
        }



        [HttpPost]
        public async Task<IActionResult> ModificarEmpleado(Empleados model)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Empleados/ModificarEmpleado";
                var response = await client.PutAsJsonAsync(url, model);

                if (response.IsSuccessStatusCode)
                {
                    TempData["Mensaje"] = "Empleado modificado correctamente.";
                    return RedirectToAction("VistaEmpleados");
                }
                else
                {
                    ViewBag.Mensaje = "Error al modificar empleado.";
                    return View(model);
                }
            }
        }

    }
}
