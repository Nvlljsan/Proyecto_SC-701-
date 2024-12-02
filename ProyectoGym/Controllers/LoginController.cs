using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc;
using ProyectoGym.Models;
using ProyectoGym.Services;
using System.Diagnostics;
using System.Security.Claims;
using System.Text.Json;
using static System.Net.WebRequestMethods;
using ProyectoGym.Models.ViewModels;
using Microsoft.Extensions.Configuration;
using System.Net.Http;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace ProyectoGym.Controllers
{
    public class LoginController : Controller
    {
        private readonly IHttpClientFactory _http;
        private readonly IConfiguration _conf;
        private readonly IMetodosComunes _comunes;

        public LoginController(IHttpClientFactory http, IConfiguration conf, IMetodosComunes comunes)
        {
            _http = http;
            _conf = conf;
            _comunes = comunes;
        }

        [HttpGet]
        public IActionResult InicioSesion()
        {
            if (User.Identity != null && User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Inicio", "Home");
            }
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> InicioSesion(Usuarios model)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Login/InicioSesion";

                JsonContent datos = JsonContent.Create(model);

                var response = await client.PostAsync(url, datos);
                var result = await response.Content.ReadFromJsonAsync<Respuesta>();

                if (result != null && result.Codigo == 0)
                {
                    var datosUsuario = JsonSerializer.Deserialize<Usuarios>((JsonElement)result.Contenido!);

                    var claims = new List<Claim>
                    {
                        new Claim(ClaimTypes.NameIdentifier, datosUsuario.UsuarioID.ToString()),
                        new Claim(ClaimTypes.Name, datosUsuario.Nombre),
                        new Claim(ClaimTypes.Email, datosUsuario.Email),
                        new Claim(ClaimTypes.Role, datosUsuario.RolID.ToString())
                    };

                    var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                    var principal = new ClaimsPrincipal(identity);

                    await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, principal);

                    return RedirectToAction("Inicio", "Home");
                }
                else
                {
                    ViewBag.Mensaje = result?.Mensaje ?? "Error desconocido.";
                    return View();
                }
            }
        }

        [HttpGet]
        public IActionResult RecuperarAcceso()
        {
            return View();
        }

        [HttpPost]
        public IActionResult RecuperarAcceso(RecuperarContrasenaVM model)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Login/RecuperarAcceso";

                JsonContent datos = JsonContent.Create(model);

                var response = client.PostAsync(url, datos).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    return RedirectToAction("RestablecerContrasena", "Login");
                }
                else
                {
                    ViewBag.Mensaje = result!.Mensaje;
                    return View();
                }
            }
        }

        [HttpGet]
        public IActionResult RestablecerContrasena(string token)
        {
            if (string.IsNullOrEmpty(token))
            {
                ViewBag.Error = "El token es inválido o ha expirado.";
                return RedirectToAction("RecuperarAcceso");
            }

            TempData["Token"] = token;
            var model = new RestablecerContrasenaVM { Token = token };
            return View(model);
        }

        [HttpPost]
        public IActionResult RestablecerContrasena(RestablecerContrasenaVM model)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Login/RestablecerContrasena";

                JsonContent datos = JsonContent.Create(model);

                var response = client.PostAsync(url, datos).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    ViewBag.Mensaje = "Revisa tu correo para obtener el enlace de recuperación.";
                    return View();
                }
                else
                {
                    ViewBag.Mensaje = result!.Mensaje;
                    return View();
                }
            }
        }


        [HttpGet]
        public IActionResult Registro()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Registro(Usuarios model)
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Login/Registro";

                JsonContent datos = JsonContent.Create(model);

                var response = client.PostAsync(url, datos).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    return RedirectToAction("InicioSesion", "Login");
                }
                else
                {
                    ViewBag.Mensaje = result!.Mensaje;
                    return View();
                }
            }
        }

        [HttpPost]
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            HttpContext.Session.Clear();
            return RedirectToAction("InicioSesion", "Login");
        }

    }
}
