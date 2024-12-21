using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using ProyectoGym.Models;
using ProyectoGym.Services;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text.Json;

namespace ProyectoGym.Controllers
{
    public class UsuariosController : Controller
    {
        private readonly IHttpClientFactory _http;
        private readonly IConfiguration _conf;
        private readonly IMetodosComunes _comunes;

        public UsuariosController(IHttpClientFactory http, IConfiguration conf, IMetodosComunes comunes)
        {
            _http = http;
            _conf = conf;
            _comunes = comunes;
        }

        [HttpGet]
        public IActionResult UsuariosLista() //FUNCIONAL 100%
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Usuarios/UsuariosLista";

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
        public IActionResult Perfil() //FUNCIONAL 100%
        {
            using (var client = _http.CreateClient())
            {
                var userActual = int.Parse(User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value);

                var url = _conf.GetSection("Variables:UrlApi").Value + $"Usuarios/UsuarioR?UsuarioID={userActual}";

                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Usuarios>().Result;
                ViewBag.verificarRol = result.RolID == 1;
                return View(result);
            }
        }

        [HttpGet]
        public IActionResult UsuarioC() //FUNCIONAL 100%
        {
            var roles = RolesLista();
            if (roles is JsonResult jsonResult && jsonResult.Value is List<Roles> rolesLista)
            {
                ViewBag.Roles = rolesLista;
            }
            return View();
        }

        [HttpPost]
        public IActionResult UsuarioC(Usuarios model) //FUNCIONAL 100%
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

        [HttpGet]
        public IActionResult UsuarioU(int UsuarioID) //FUNCIONAL 100%
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + $"Usuarios/UsuarioR?usuarioID={UsuarioID}";

                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Usuarios>().Result;

                if (result != null)
                {
                    var roles = RolesLista();
                    if (roles is JsonResult jsonResult && jsonResult.Value is List<Roles> rolesLista)
                    {
                        ViewBag.Roles = rolesLista;
                    }

                    ViewBag.verificarRol = result.RolID == 1;

                    return View(result); 
                }
                else
                {
                    ViewBag.Mensaje = "No se encontraron datos del usuario.";
                    return RedirectToAction("UsuariosLista");
                }
            }
        }

        [HttpPost]
        public IActionResult UsuarioU(Usuarios model) //FUNCIONAL 100%
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Usuarios/UsuarioU";

                model.Contrasena = _comunes.Encrypt(model.Contrasena);
                JsonContent datos = JsonContent.Create(model);

                var response = client.PutAsync(url, datos).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    return RedirectToAction("UsuariosLista");
                }
                else
                {
                    var roles = RolesLista();
                    if (roles is JsonResult jsonResult && jsonResult.Value is List<Roles> rolesLista)
                    {
                        ViewBag.Roles = rolesLista;
                    }

                    ViewBag.Mensaje = result!.Mensaje;
                    return View(model);
                }
            }
        }

        [HttpPost]
        public IActionResult UsuarioD(int usuarioID) //FUNCIONAL 100%
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Usuarios/UsuarioD?usuarioID=" + usuarioID;

                var response = client.DeleteAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    return RedirectToAction("UsuariosLista");
                }
                else
                {
                    ViewBag.Mensaje = result?.Mensaje ?? "Error desconocido";
                    return RedirectToAction("UsuariosLista");
                }
            }
        }

        [HttpGet]
        public IActionResult EditarPerfil()
        {
            using (var client = _http.CreateClient())
            {
                var userActual = int.Parse(User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value);

                var url = _conf.GetSection("Variables:UrlApi").Value + $"Usuarios/UsuarioR?UsuarioID={userActual}";

                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Usuarios>().Result;

                if (result != null)
                {
                    var roles = RolesLista();
                    if (roles is JsonResult jsonResult && jsonResult.Value is List<Roles> rolesLista)
                    {
                        ViewBag.Roles = rolesLista;
                    }

                    ViewBag.Admin = result.RolID == 1;
                    ViewBag.Instruct = result.RolID == 2;
                    ViewBag.Client = result.RolID == 3;
                    ViewBag.Emp = result.RolID == 4;

                    return View(result);
                }
                else
                {
                    TempData["Mensaje"] = "No se encontraron datos del perfil.";
                    return RedirectToAction("Perfil");
                }
            }
        }

        [HttpPost]
        public IActionResult EditarPerfil(Usuarios model)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Usuarios/UsuarioU";

                var response = client.PutAsJsonAsync(url, model).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    TempData["Mensaje"] = "Perfil actualizado correctamente.";
                    return RedirectToAction("Perfil");
                }
                else
                {
                    ViewBag.Mensaje = result?.Mensaje ?? "Error al actualizar el perfil.";
                    return View("PerfilEditar", model);
                }
            }
        }

        [HttpPost]
        public IActionResult EliminarPerfil(int UsuarioID) //FUNCIONAL 100%
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Usuarios/UsuarioD?usuarioID=" + UsuarioID;

                var response = client.DeleteAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
                    return RedirectToAction("InicioSesion", "Login");
                }
                else
                {
                    ViewBag.Mensaje = result?.Mensaje ?? "Error desconocido";
                    return RedirectToAction("Perfil");
                }
            }
        }





        //=================================================[Metodos Auxiliares]=================================================
        private IActionResult RolesLista() //FUNCIONAL 100%
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Usuarios/RolesLista";

                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    var datosContenido = JsonSerializer.Deserialize<List<Roles>>((JsonElement)result.Contenido!);
                    return Json(datosContenido);
                }
                return Json(new List<Roles>()); 
            }
        }
    }
}
