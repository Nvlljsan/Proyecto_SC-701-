using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using ProyectoGymAPI.Models;
using System.Data;
using System.Security.Cryptography;
using System.Text;

namespace ProyectoGymAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsuariosController : ControllerBase
    {
        private readonly IConfiguration _conf;
        private readonly IHostEnvironment _env;

        public UsuariosController(IConfiguration conf, IHostEnvironment env)
        {
            _conf = conf;
            _env = env;
        }

        [HttpGet]
        [Route("UsuariosLista")]
        public IActionResult UsuariosLista()
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var result = context.Query<Usuarios>("UsuariosLista", new { });

                if (result != null)
                {
                    respuesta.Codigo = 0;
                    respuesta.Contenido = result;
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "No hay usuarios registrados en el sistema";
                }
                return Ok(respuesta);
            }
        }


        [HttpPost]
        [Route("UsuarioC")]
        public IActionResult UsuarioC(Usuarios model)
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();

                if (model.RolID == 0) //Esto es para hacer que cliente sea default
                {
                    model.RolID = 3;  // Cliente
                }

                var result = context.Execute("UsuarioC", new { model.Nombre, model.Apellido, model.Email, model.Contrasena, model.Telefono, model.Direccion, model.RolID });

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

        [HttpGet]
        [Route("UsuarioR")]
        public IActionResult UsuarioR(int usuarioID)
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var result = context.QueryFirstOrDefault<Usuarios>("UsuarioR", new { UsuarioID = usuarioID });

                if (result != null)
                {
                    return Ok(result);
                }
                else
                {
                    return NotFound(new { Mensaje = "Usuario no encontrado." });
                }
            }
        }

        [HttpPut]
        [Route("UsuarioU")]
        public IActionResult UsuarioU(Usuarios model)
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();

                var result = context.Execute("UsuarioU", new { model.UsuarioID, model.Nombre, model.Apellido, model.Email, model.Contrasena, model.Telefono, model.Direccion, model.RolID });

                if (result > 0)
                {
                    respuesta.Codigo = 0;
                    respuesta.Mensaje = "Usuario actualizado con éxito.";
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "Error al actualizar el usuario. Verifique si el UsuarioID es válido.";
                }
                return Ok(respuesta);
            }
        }

        [HttpDelete]
        [Route("UsuarioD")]
        public IActionResult UsuarioD(int usuarioID)
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var result = context.Execute("UsuarioD", new { UsuarioID = usuarioID });

                if (result > 0)
                {
                    respuesta.Codigo = 0;
                    respuesta.Mensaje = "Usuario eliminado con éxito.";
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "Error al eliminar el usuario. Verifique si el UsuarioID es válido.";
                }
                return Ok(respuesta);
            }
        }

        //======================================================[Metodos Auxiliares]=====================================================================
        [HttpGet]
        [Route("RolesLista")]
        public IActionResult RolesLista()
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var result = context.Query<Roles>("RolesLista", new { });

                if (result.Any())
                {
                    respuesta.Codigo = 0;
                    respuesta.Contenido = result;
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "No hay vendedores en el sistema";
                }

                return Ok(respuesta);
            }
        }
    }
}
