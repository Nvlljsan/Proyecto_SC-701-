using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc;
using ProyectoGym.Models;
using ProyectoGym.Services;
using System.Security.Claims;
using System.Text.Json;
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
        public IActionResult InicioSesion() //FUNCIONAL 100%
        {
            if (User.Identity != null && User.Identity.IsAuthenticated) //Confirmar con User, que es de Claims
            {
                return RedirectToAction("Inicio", "Home");
            }
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> InicioSesion(Usuarios model) //FUNCIONAL 100% (Uso de Claims)
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

                    var claims = new List<Claim> //Uso de Claims
                    {
                        new Claim(ClaimTypes.NameIdentifier, datosUsuario.UsuarioID.ToString()),
                        new Claim(ClaimTypes.Name, datosUsuario.Nombre),
                        new Claim(ClaimTypes.Email, datosUsuario.Email),
                        new Claim(ClaimTypes.Role, datosUsuario.RolID.ToString())
                    };

                    var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme); //Llamar a la lista y autenticarla
                    var principal = new ClaimsPrincipal(identity);

                    await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, principal);

                    return RedirectToAction("Inicio", "Home");
                }
                else
                {
                    ViewBag.Mensaje = result?.Mensaje;
                    return View();
                }
            }
        }

        [HttpGet]
        public IActionResult Registro() //FUNCIONAL 100%
        {
            return View();
        }

        [HttpPost]
        public IActionResult Registro(Usuarios model) //FUNCIONAL 100%
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

        [HttpGet]
        public IActionResult RecuperarAcceso() //FUNCIONAL 100%
        {
            return View();
        }

        [HttpPost]
        public IActionResult RecuperarAcceso(Usuarios model) //FUNCIONAL 100%
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Login/RecuperarAcceso";

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

        [HttpGet]
        public IActionResult CambiarContrasena(string token) //FUNCIONAL 100%
        {
            if (string.IsNullOrEmpty(token))
            {
                ViewBag.Error = "El token es inválido o ha expirado.";
                return RedirectToAction("RecuperarAcceso");
            }

            TempData["Token"] = token;
            var model = new Tokens { Token = token };
            return View(model);
        }

        [HttpPost]
        public IActionResult CambiarContrasena(Tokens model) //FUNCIONAL 100%
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Login/CambiarContrasena";

                JsonContent datos = JsonContent.Create(model);

                // Log para inspeccionar el JSON enviado
                string jsonDatos = datos.ReadAsStringAsync().Result;
                Console.WriteLine($"JSON Enviado: {jsonDatos}");

                var response = client.PostAsync(url, datos).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    ViewBag.Mensaje = "Tu contraseña ha sido restablecida correctamente.";
                    return RedirectToAction("InicioSesion", "Login");
                }
                else
                {
                    ViewBag.Mensaje = result!.Mensaje;
                    return View(model); 
                }
            }
        }

        [HttpPost]
        public async Task<IActionResult> Logout() //FUNCIONAL 100%
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("InicioSesion", "Login");
        }

    }
}
