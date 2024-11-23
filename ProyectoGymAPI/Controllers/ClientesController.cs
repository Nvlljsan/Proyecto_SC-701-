using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using ProyectoGymAPI.Models;

namespace ProyectoGymAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ClientesController : ControllerBase
    {

        private readonly IConfiguration _conf;
        private readonly IHostEnvironment _env;

        public ClientesController(IConfiguration conf, IHostEnvironment env)
        {
            _conf = conf;
            _env = env;
        }


        [HttpGet]
        [Route("ClientesLista")]
        public IActionResult ClientesLista()
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var result = context.Query<Clientes>("ClientesR", new { });

                if (result.Any())
                {
                    respuesta.Codigo = 0;
                    respuesta.Contenido = result;
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "No hay usuarios registrados en este momento";
                }

                return Ok(respuesta);
            }

        }

        [HttpGet]
        [Route("ConsultarCliente")]
        public IActionResult ConsultarCliente(int ClienteID)
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var result = context.QueryFirstOrDefault<Clientes>("ConsultarCliente", new { ClienteID });

                if (result != null)
                {

                    respuesta.Codigo = 0;
                    respuesta.Contenido = result;
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "No hay usuarios registrados en este momento";
                }

                return Ok(respuesta);
            }
        }

        [HttpPut]
        [Route("ActualizarCliente")]
        public IActionResult ActualizarCliente(Clientes model)
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                if (model.FechaFinMembresia > DateTime.Now)
                {
                    model.MembresiaActiva = true;
                }
                else
                {
                    model.MembresiaActiva = false;
                };

                var respuesta = new Respuesta();

                var result = context.Execute("ActualizarCliente", new
                {
                    model.ClienteID,

                    model.FechaInicioMembresia,
                    model.FechaFinMembresia,
                    model.MembresiaActiva



                });

                if (result > 0)
                {
                    respuesta.Codigo = 0;
                    respuesta.Mensaje = "Su información de Cliente se ha actualizado correctamente";
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "Su información de Cliente no se ha actualizado correctamente";
                }

                return Ok(respuesta);
            }
        }

        [HttpDelete]
        [Route("ClienteInactivo")]
        public IActionResult ClienteInactivo(int ClienteID)
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                
                   var respuesta = new Respuesta();
                var result = context.QueryFirstOrDefaultAsync<Clientes>("ClienteD", new { ClienteID });

                            
                if (result != null)
                {
                    respuesta.Codigo = 0;
                    respuesta.Mensaje = "Su información de Cliente se ha Inactivado correctamente";
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "Su información de Cliente no se ha Inactivado correctamente";
                }

                return Ok(respuesta);
            }
        }
    }
}
