using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using ProyectoGymAPI.Models;
using System.Data;

namespace ProyectoGymAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ReservasController : ControllerBase
    {

        private readonly IConfiguration _conf;
        private readonly IHostEnvironment _env;
        public ReservasController(IConfiguration conf, IHostEnvironment env)
        {
            _conf = conf;
            _env = env;
        }


        [HttpGet]
        [Route("ObtenerReservas")]
        public async Task<IActionResult> GetReservas()
        {
            using (var connection = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var reservas = await connection.QueryAsync("sp_ObtenerReservas", commandType: CommandType.StoredProcedure);
                return Ok(reservas);
            }
        }

        [HttpPost]
        [Route("InsertarReserva")]
        public async Task<IActionResult> InsertReserva([FromBody] Reservas reserva)
        {
            using (var connection = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var parameters = new
                {
                    UsuarioID = reserva.UsuarioID,
                    FechaReserva = reserva.FechaReserva,
                    HoraInicio = reserva.HoraInicio,
                    HoraFin = reserva.HoraFin,
                    MaquinaID = reserva.MaquinaID
                };
                await connection.ExecuteAsync("sp_InsertarReserva", parameters, commandType: CommandType.StoredProcedure);
                return Ok();
            }
        }

        [HttpPut]
        [Route("ActualizarEstadoReserva")]
        public async Task<IActionResult> ActualizarEstadoReserva(int id)
        {
            try
            {
           

                using (var connection = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
                {
                    var parameters = new
                    {
                        ReservaID = id,
         
                    };

                    var rowsAffected = await connection.ExecuteAsync("sp_ActualizarEstadoReserva", parameters, commandType: CommandType.StoredProcedure);
                    if (rowsAffected > 0)
                    {
                        return Ok(new { message = "Estado de la reserva actualizado exitosamente." });
                    }

                    return BadRequest(new { message = "No se pudo actualizar el estado de la reserva." });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al actualizar el estado de la reserva: {ex.Message}");
            }
        }

        [HttpDelete("EliminarReserva/{id}")]
        public async Task<IActionResult> EliminarReserva(int id)
        {
            try
            {
                using (var connection = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
                {
                    var parameters = new { ReservaID = id };

                    await connection.ExecuteAsync("sp_EliminarReserva", parameters, commandType: CommandType.StoredProcedure);
                    return Ok(new { message = "Reserva eliminada exitosamente." });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al eliminar la reserva: {ex.Message}");
            }
        }
    }
}