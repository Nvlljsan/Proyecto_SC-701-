using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using ProyectoGym.Models;
using System.Net.Http;
using static System.Net.WebRequestMethods;


namespace ProyectoGym.Controllers
{
    public class PagosController : Controller
    {
        private readonly IHttpClientFactory _http;
        private readonly IConfiguration _conf;

        public PagosController(IHttpClientFactory http, IConfiguration conf)
        {
            _http = http;
            _conf = conf;
        }

        // GET: Pagos
        [HttpGet]
        public async Task<IActionResult> ConsultarPagos()
        {
            try
            {
                var client = _http.CreateClient();
                var url = _conf.GetSection("Variables:UrlApi").Value + "Pagos/ObtenerPagos";

                var response = await client.GetAsync(url);
                response.EnsureSuccessStatusCode();

                var pagos = await response.Content.ReadFromJsonAsync<List<PagosViewModel>>();
                return View(pagos);
            }
            catch (Exception ex)
            {

                return StatusCode(500, $"Error al consultar pagos: {ex.Message}");
            }
        }

      
        public IActionResult RegistrarPago()
        {
            return View();
        }

        // POST: Insertar Pago
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InsertarPago(Pagos pago)
        {
            try
            {
                var client = _http.CreateClient();
                var url = _conf.GetSection("Variables:UrlApi").Value + "Pagos/InsertarPago";

                var response = await client.PostAsJsonAsync(url, pago);

                if (response.IsSuccessStatusCode)
                {
                    return RedirectToAction(nameof(ConsultarPagos));
                }

                ModelState.AddModelError(string.Empty, "Error al registrar el pago.");
                return View("RegistrarPago",pago);
            }
            catch (Exception ex)
            {
       
                ModelState.AddModelError(string.Empty, $"Excepción: {ex.Message}");
                return View("RegistrarPago", pago);
            }
        }

        // GET: Eliminar Pago
        public async Task<IActionResult> EliminarPago(int id)
        {
            try
            {
                var client = _http.CreateClient();
                var url = _conf.GetSection("Variables:UrlApi").Value + $"Pagos/EliminarPago/{id}";

                var response = await client.DeleteAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    return RedirectToAction(nameof(ConsultarPagos));
                }

                return BadRequest("Error al eliminar el pago.");
            }
            catch (Exception ex)
            {
 
                return StatusCode(500, $"Excepción al eliminar el pago: {ex.Message}");
            }
        }
    }

}
