using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using ProyectoGym.Models;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;
using System.Net.Http;
using QuestPDF.Fluent;
using System.Text.Json;
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
            ConsultarUsuarios();
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

        [HttpGet]
        public async Task<IActionResult> GenerarReportePagos()
        {
            using (var client = _http.CreateClient())
            {

                var url = _conf.GetSection("Variables:UrlApi").Value + "Pagos/ObtenerPagos";

                var response = await client.GetAsync(url);

                if (!response.IsSuccessStatusCode)
                {
                    return StatusCode((int)response.StatusCode, "Error al obtener datos del API.");
                }

                var pagos = await response.Content.ReadFromJsonAsync<List<PagosViewModel>>();

                if (pagos == null || !pagos.Any())
                {
                    return Content("No hay datos disponibles para generar el reporte.");
                }

                var PdfDoc = Document.Create(container =>
                {
                    container.Page(page =>
                    {
                        page.Size(PageSizes.A4);
                        page.Margin(2, Unit.Centimetre);
                        page.DefaultTextStyle(TextStyle.Default.Size(12));
                        page.Header().Text("Reporte de Pagos").Bold().FontSize(18).AlignCenter();
                        page.Content().Table(table =>
                        {
                            table.ColumnsDefinition(columns =>
                            {
                                columns.ConstantColumn(50);  // ID
                                columns.RelativeColumn();    // Usuario
                                columns.ConstantColumn(80);  // Monto
                                columns.ConstantColumn(100); // Fecha
                                columns.RelativeColumn();    // Método de Pago
                            });

                            table.Header(header =>
                            {
                                header.Cell().Text("ID").Bold();
                                header.Cell().Text("Usuario").Bold();
                                header.Cell().Text("Monto").Bold();
                                header.Cell().Text("Fecha").Bold();
                                header.Cell().Text("Método de Pago").Bold();
                            });

                            foreach (var pago in pagos)
                            {
                                table.Cell().Text(pago.PagoID.ToString());
                                table.Cell().Text(pago.UsuarioNombre);
                                table.Cell().Text($"${pago.Monto:F2}");
                                table.Cell().Text(pago.FechaPago.ToString("dd/MM/yyyy"));
                                table.Cell().Text(pago.MetodoPago);
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
                return File(pdfBytes, "application/pdf", "Reporte_Pagos.pdf");
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
