using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using ProyectoGym.Models;
using System.Net.Http.Headers;
using System.Text.Json;

namespace ProyectoGym.Controllers
{
    public class VentasController : Controller
    {
        private readonly IHttpClientFactory _http;
        private readonly IConfiguration _conf;

        public VentasController(IHttpClientFactory http, IConfiguration conf)
        {
            _http = http;
            _conf = conf;
        }

        [HttpGet]
        public async Task<IActionResult> ConsultarVentas()
        {
            try
            {
                var client = _http.CreateClient();
                var url = _conf.GetSection("Variables:UrlApi").Value + "Ventas/ObtenerVentas";

                var response = await client.GetAsync(url);
                response.EnsureSuccessStatusCode();

                var ventas = await response.Content.ReadFromJsonAsync<List<VentaViewModel>>();
                return View(ventas);
            }
            catch (Exception ex)
            {
       
                return StatusCode(500, $"Error al consultar ventas: {ex.Message}");
            }
        }
        

        // GET: Crear Venta
        public IActionResult RegistrarVenta()
        {
            ConsultarProductos();
            ConsultarUsuarios();
            return View();
        }

        // POST: Insertar Venta
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InsertarVenta(Ventas venta)
        {
            try
            {
                var client = _http.CreateClient();
                var url = _conf.GetSection("Variables:UrlApi").Value + "Ventas/InsertarVenta";

                var response = await client.PostAsJsonAsync(url, venta);

                if (response.IsSuccessStatusCode)
                {
                    return RedirectToAction(nameof(ConsultarVentas));
                }

                ModelState.AddModelError(string.Empty, "Error al registrar la venta.");
                return View("RegistrarVenta",venta);
            }
            catch (Exception ex)
            {
 
                ModelState.AddModelError(string.Empty, $"Excepción: {ex.Message}");
                return View("RegistrarVenta",venta);
            }
        }

        // GET: Eliminar Venta
        public async Task<IActionResult> EliminarVenta(int id)
        {
            try
            {
                var client = _http.CreateClient();
                var url = _conf.GetSection("Variables:UrlApi").Value + $"Ventas/EliminarVenta/{id}";

                var response = await client.DeleteAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    return RedirectToAction(nameof(ConsultarVentas));
                }

                return BadRequest("Error al eliminar la venta .");
            }
            catch (Exception ex)
            {
          
                return StatusCode(500, $"Excepción al eliminar la venta : {ex.Message}");
            }
        }

        private void ConsultarProductos()
        {
            using (var client = _http.CreateClient())
            {
                string url = _conf.GetSection("Variables:UrlApi").Value + "Ventas/ObtenerProductos";
            

                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;
                var responseBody = response.Content.ReadAsStringAsync().Result;
                Console.WriteLine($"Contenido de la respuesta: {responseBody}");

                if (result != null && result.Codigo == 0)   
                {
                    ViewBag.DropDownProductos = result.Contenido;
                    ViewBag.DropDownProductos = JsonSerializer.Deserialize<List<Productos>>((JsonElement)result.Contenido!);
                }
            }
        }

        private void ConsultarUsuarios()
        {
            using (var client = _http.CreateClient())
            {
                string url = _conf.GetSection("Variables:UrlApi").Value + "Usuarios/UsuariosLista";


                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;
                var responseBody = response.Content.ReadAsStringAsync().Result;
                Console.WriteLine($"Contenido de la respuesta: {responseBody}");

                if (result != null && result.Codigo == 0)
                {
                    ViewBag.DropDownUsuarios = result.Contenido;
                    ViewBag.DropDownUsuarios = JsonSerializer.Deserialize<List<Usuarios>>((JsonElement)result.Contenido!);
                }
            }
        }
    }

}
