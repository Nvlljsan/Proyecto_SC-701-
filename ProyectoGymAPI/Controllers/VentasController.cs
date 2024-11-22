using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using ProyectoGymAPI.Models;
using System.Data;

namespace ProyectoGymAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class VentasController : ControllerBase
    {

        private readonly IConfiguration _conf;
        private readonly IHostEnvironment _env;
        public VentasController(IConfiguration conf, IHostEnvironment env)
        {
            _conf = conf;
            _env = env;
        }



        [HttpGet]
        [Route("ObtenerVentas")]
        public async Task<IActionResult> ObtenerVentas()
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var procedimiento = "GetVentas";
                var ventas = await context.QueryAsync<VentasViewModel>(procedimiento);
                return Ok(ventas);
            }
        }

        [HttpPost]
        [Route("InsertarVenta")]
        public async Task<IActionResult> InsertarVenta([FromBody] Ventas venta)
        {
            using (var connection = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var parameters = new
                {
                    venta.UsuarioID,
                    venta.ProductoID,
                    venta.Cantidad,
                    venta.FechaVenta,
                    venta.Total
                };
                await connection.ExecuteAsync("InsertVenta", parameters, commandType: CommandType.StoredProcedure);
                return Ok();
            }
        }

        [HttpDelete("EliminarVenta/{id}")]
        public async Task<IActionResult> EliminarVenta(int id)
        {
            using (var connection = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                await connection.ExecuteAsync("DeleteVenta", new { VentaID = id }, commandType: CommandType.StoredProcedure);
                return Ok();
            }
        }
    }

}