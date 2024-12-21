using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using ProyectoGym.Models;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;
using QuestPDF.Fluent;
using System.Text.Json;


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
            ConsultarUsuarios();
            ConsultarMaquinas();
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
                return View("RegistrarReserva", reserva);
            }
            catch (Exception ex)
            {

                ModelState.AddModelError(string.Empty, $"Excepción: {ex.Message}");
                return View("RegistrarReserva", reserva);
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

        [HttpGet]
        public async Task<IActionResult> GenerarReporteReservas()
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Reservas/ObtenerReservas";

                var response = await client.GetAsync(url);
                var reservas = await response.Content.ReadFromJsonAsync<List<ReservasViewModel>>();

                if (reservas == null || !reservas.Any())
                {
                    return Content("No hay datos disponibles para generar el reporte.");
                }

                // Generar el PDF
                var PdfDoc = Document.Create(container =>
                {
                    container.Page(page =>
                    {
                        page.Size(PageSizes.A4);
                        page.Margin(2, Unit.Centimetre);
                        page.DefaultTextStyle(TextStyle.Default.Size(12));
                        page.Header().Text("Reporte de Reservas").Bold().FontSize(18).AlignCenter();
                        page.Content().Table(table =>
                        {
                            table.ColumnsDefinition(columns =>
                            {
                                columns.ConstantColumn(50);  // ID
                                columns.RelativeColumn(100); // Usuario
                                columns.RelativeColumn(100); // Máquina
                                columns.ConstantColumn(100); // Fecha
                                columns.ConstantColumn(100); // Hora Inicio
                                columns.ConstantColumn(100); // Hora Fin
                            });

                            table.Header(header =>
                            {
                                header.Cell().Text("ID").Bold();
                                header.Cell().Text("Usuario").Bold();
                                header.Cell().Text("Máquina").Bold();
                                header.Cell().Text("Fecha").Bold();
                                header.Cell().Text("Hora Inicio").Bold();
                                header.Cell().Text("Hora Fin").Bold();
                            });

                            foreach (var reserva in reservas)
                            {
                                table.Cell().Text(reserva.ReservaID.ToString());
                                table.Cell().Text(reserva.UsuarioNombre);
                                table.Cell().Text(reserva.MaquinaNombre ?? "Sin asignar");
                                table.Cell().Text(reserva.FechaReserva.ToString("dd/MM/yyyy"));
                                table.Cell().Text(reserva.HoraInicio.ToString(@"hh\:mm"));
                                table.Cell().Text(reserva.HoraFin.ToString(@"hh\:mm"));
                            }
                        });

                        page.Footer().AlignCenter().Text(text =>
                        {
                            text.Span("Página ");
                            text.CurrentPageNumber();
                            text.Span(" de ");
                            text.TotalPages();
                        });
                    });
                });

                var pdfBytes = PdfDoc.GeneratePdf();
                return File(pdfBytes, "application/pdf", "Reporte_Reservas.pdf");
            }
        }


        private void ConsultarMaquinas()
        {
            using (var client = _http.CreateClient())
            {
                string url = _conf.GetSection("Variables:UrlApi").Value + "Maquinas/MaquinasLista";


                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;
                var responseBody = response.Content.ReadAsStringAsync().Result;
                Console.WriteLine($"Contenido de la respuesta: {responseBody}");

                if (result != null && result.Codigo == 0)
                {
                    ViewBag.DropDownMaquinas = result.Contenido;
                    ViewBag.DropDownMaquinas = JsonSerializer.Deserialize<List<Maquinas>>((JsonElement)result.Contenido!);
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
