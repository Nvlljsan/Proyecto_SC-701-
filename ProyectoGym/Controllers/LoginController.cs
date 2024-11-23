using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc;
using ProyectoGym.Models;
using ProyectoGym.Services;
using System.Diagnostics;
using System.Security.Claims;
using System.Text.Json;
using static System.Net.WebRequestMethods;

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

                    // Autenticar al usuario
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



        public IActionResult RecuperarClave()
        {
            return View();
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
    }
}
