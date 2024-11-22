using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using ProyectoGymAPI.Models;
using System.Data;

namespace ProyectoGymAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PagosController : ControllerBase
    {
        private readonly IConfiguration _conf;
        private readonly IHostEnvironment _env;
        public PagosController(IConfiguration conf, IHostEnvironment env)
        {
            _conf = conf;
            _env = env;
        }

        [HttpGet]
        [Route("ObtenerPagos")]
        public async Task<IActionResult> Obtenerpagos()
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var procedimiento = "GetPagos";
                var pagos = await context.QueryAsync<PagosViewModel>(procedimiento);
                return Ok(pagos);
            }
        }

        [HttpPost]
        [Route("InsertarPago")]
        public async Task<IActionResult> InsertarPago([FromBody] Pagos pago)
        {
            using (var connection = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var parameters = new
                {
                    pago.UsuarioID,
                    pago.Monto,
                    pago.FechaPago,
                    pago.MetodoPago
                };
                await connection.ExecuteAsync("InsertPago", parameters, commandType: CommandType.StoredProcedure);
                return Ok();
            }
        }

        [HttpDelete("EliminarPago/{id}")]
        public async Task<IActionResult> EliminarPago(int id)
        {
            using (var connection = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                await connection.ExecuteAsync("DeletePago", new { PagoID = id }, commandType: CommandType.StoredProcedure);
                return Ok();
            }
        }
    }
}