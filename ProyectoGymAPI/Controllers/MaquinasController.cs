using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using ProyectoGymAPI.Models;

namespace ProyectoGymAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MaquinasController : ControllerBase
    {
        private readonly IConfiguration _conf;
        private readonly IHostEnvironment _env;

        public MaquinasController(IConfiguration conf, IHostEnvironment env)
        {
            _conf = conf;
            _env = env;
        }

        [HttpPost]
        [Route("MaquinasC")]
        public IActionResult MaquinasC(Maquinas model)
        {
            

            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var result = context.Execute("MaquinasC", new { model.Nombre, model.Descripcion, model.Ubicacion});

                if (result > 0)
                {
                    respuesta.Codigo = 0;
                    respuesta.Mensaje = "Maquina registrada con éxito.";
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "Error al  registrada una Maquina.";
                }

                return Ok(respuesta);
            }
        }


        [HttpGet]
        [Route("MaquinasLista")]
        public IActionResult MaquinasLista()
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var result = context.Query<Maquinas>("MaquinasR", new { });

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
        [Route("ConsultarMaquinas")]
        public IActionResult ConsultarMaquinas(int MaquinaID)
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var result = context.QueryFirstOrDefault<Maquinas>("MaquinasR", new { MaquinaID });

                if (result != null)
                {

                    respuesta.Codigo = 0;
                    respuesta.Contenido = result;
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "No hay Maquinas registradas en este momento";
                }

                return Ok(respuesta);
            }
        }

        [HttpPut]
        [Route("MaquinasU")]
        public IActionResult MaquinasU(Maquinas model)
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
               

                var respuesta = new Respuesta();

                var result = context.Execute("MaquinasU", new
                {
                    model.MaquinaID,

                    model.Nombre,
                    model.Descripcion,
                    model.Ubicacion,
                    model.Estado



                });

                if (result > 0)
                {
                    respuesta.Codigo = 0;
                    respuesta.Mensaje = "Su información se ha actualizado correctamente";
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "Su información se ha actualizado correctamente";
                }

                return Ok(respuesta);
            }
        }

    }
}
