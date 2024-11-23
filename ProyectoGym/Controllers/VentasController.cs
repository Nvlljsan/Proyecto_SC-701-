using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using ProyectoGym.Models;

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

                var ventas = await response.Content.ReadFromJsonAsync<List<VentasViewModel>>();
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
    }

}
