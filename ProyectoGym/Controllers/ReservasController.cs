using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using ProyectoGym.Models;


namespace ProyectoGym.Controllers
{
    public class ReservasController : Controller
    {
        private readonly IHttpClientFactory _http;
        private readonly IConfiguration _conf;

        public ReservasController(IHttpClientFactory http, IConfiguration conf)
        {
            _http = http;
            _conf = conf;
        }

        // GET: Reservas
        [HttpGet]
        public async Task<IActionResult> ConsultarReservas()
        {
            try
            {
                var client = _http.CreateClient();
                var url = _conf.GetSection("Variables:UrlApi").Value + "Reservas/ObtenerReservas";

                var response = await client.GetAsync(url);
                response.EnsureSuccessStatusCode();

                var reservas = await response.Content.ReadFromJsonAsync<List<ReservasViewModel>>();
                return View(reservas);
            }
            catch (Exception ex)
            {

                return StatusCode(500, $"Error al consultar pagos: {ex.Message}");
            }
        }

        // GET: Crear Reserva
        public IActionResult RegistrarReserva()
        {
            return View();
        }

        // POST: Crear Reserva
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InsertarReserva(Reservas reserva)
        {
            try
            {
                var client = _http.CreateClient();
                var url = _conf.GetSection("Variables:UrlApi").Value + "Reservas/InsertarReserva";

                var response = await client.PostAsJsonAsync(url, reserva);

                if (response.IsSuccessStatusCode)
                {
                    return RedirectToAction(nameof(ConsultarReservas));
                }

                ModelState.AddModelError(string.Empty, "Error al registrar la reserva.");
                return View("RegistrarPago", reserva);
            }
            catch (Exception ex)
            {

                ModelState.AddModelError(string.Empty, $"Excepción: {ex.Message}");
                return View("RegistrarPago", reserva);
            }
        }

        // GET: Eliminar Reserva
        public async Task<IActionResult> EliminarReserva(int id)
        {
            try
            {
                var client = _http.CreateClient();
                var url = _conf.GetSection("Variables:UrlApi").Value + $"Reservas/EliminarReserva/{id}";

                var response = await client.DeleteAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    return RedirectToAction(nameof(ConsultarReservas));
                }

                return BadRequest("Error al eliminar el pago.");
            }
            catch (Exception ex)
            {

                return StatusCode(500, $"Excepción al eliminar el pago: {ex.Message}");
            }
        }

        [HttpPost]
        public async Task<IActionResult> ActualizarEstadoReserva(int id, bool estado)
        {
            try
            {
                Console.WriteLine($"ID: {id}, Estado: {estado}"); // Log para verificar los valores recibidos

                var client = _http.CreateClient();
                var url = _conf.GetSection("Variables:UrlApi").Value + $"Reservas/ActualizarEstadoReserva?id={id}";

                var response = await client.PutAsJsonAsync(url, estado);

                if (response.IsSuccessStatusCode)
                {
                    return RedirectToAction(nameof(ConsultarReservas));
                }

                ModelState.AddModelError(string.Empty, "Error al actualizar el estado de la reserva.");
                return RedirectToAction(nameof(ConsultarReservas));
            }
            catch (Exception ex)
            {
                ModelState.AddModelError(string.Empty, $"Excepción: {ex.Message}");
                return RedirectToAction(nameof(ConsultarReservas));
            }
        }

    }
}
