using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using ProyectoGymAPI.Models;
using System.Data;

namespace ProyectoGymAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private readonly IConfiguration _conf;
        private readonly IHostEnvironment _env;

        public LoginController(IConfiguration conf, IHostEnvironment env)
        {
            _conf = conf;
            _env = env;
        }

        //Aun tengo que configurar bien el inicio de sesion
        [HttpPost]
        [Route("InicioSesion")]
        public IActionResult InicioSesion(Usuarios model)
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var result = context.QueryFirstOrDefault<Usuarios>("InicioSesion", new { model.Email, model.Contrasena });

                if (result != null)
                {
                    respuesta.Codigo = 0;
                    respuesta.Contenido = result;
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "Su información no se ha validado correctamente";
                }

                return Ok(respuesta);
            }
        }


        [HttpPost]
        [Route("Registro")]
        public IActionResult Registro(Usuarios model)
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();

                if (model.RolID == 0) //Esto es para hacer que cliente sea default
                {
                    model.RolID = 3;  // Cliente
                }

                var result = context.Execute("Registro", new { model.Nombre, model.Apellido, model.Email, model.Contrasena, model.Telefono, model.Direccion, model.RolID });

                if (result > 0)
                {
                    respuesta.Codigo = 0;
                    respuesta.Mensaje = "Usuario registrado con éxito.";
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "Error al registrar un usuario.";
                }

                return Ok(respuesta);
            }
        }
    }
}
