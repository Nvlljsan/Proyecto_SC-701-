using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using ProyectoGymAPI.Models;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

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
        public IActionResult UsuariosLista() //FUNCIONA 100%
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
        public IActionResult UsuarioC(Usuarios model) //FUNCIONAL 100%
        {
            if (model.RolID == 0 || model.RolID == null)
            {
                model.RolID = 3;
            }

            model.Contrasena = Encrypt(model.Contrasena);

            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var correoExistente = context.QueryFirstOrDefault<Usuarios>("UsuariosValidar", new { model.Email, model.Telefono });

                if (correoExistente != null)
                {
                    return BadRequest(new
                    {
                        Codigo = -1,
                        Mensaje = "El correo o telefono ya está registrado. Por favor, use uno diferente."
                    });
                }

                if (model.Telefono.Length != 8 || !model.Telefono.All(char.IsDigit))
                {
                    return BadRequest(new
                    {
                        Codigo = -1,
                        Mensaje = "El número de teléfono debe contener exactamente 8 dígitos y solo números."
                    });
                }

                var respuesta = new Respuesta();
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
        public IActionResult UsuarioR(int usuarioID) //FUNCIONAL 100%
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
        public IActionResult UsuarioU(Usuarios model) //FUNCIONA 100%
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                if (model.Telefono.Length != 8 || !model.Telefono.All(char.IsDigit))
                {
                    return BadRequest(new
                    {
                        Codigo = -1,
                        Mensaje = "El número de teléfono debe contener exactamente 8 dígitos y solo números."
                    });
                }

                var respuesta = new Respuesta();
                var result = context.Execute("UsuarioU", new { model.UsuarioID, model.Nombre, model.Apellido, model.Email, model.Telefono, model.Direccion, model.RolID, model.Activo });

                if (result > 0)
                {
                    respuesta.Codigo = 0;
                    respuesta.Mensaje = "Usuario actualizado con éxito.";
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "Error al actualizar el usuario.";
                }
                return Ok(respuesta);
            }
        }

        [HttpDelete]
        [Route("UsuarioD")]
        public IActionResult UsuarioD(int usuarioID) //FUNCIONA 100%
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
                    respuesta.Mensaje = "Error al eliminar el usuario.";
                }
                return Ok(respuesta);
            }
        }

        //PENDIENTE UN DESACTIVAR USUARIO

        //======================================================[Metodos Auxiliares]=====================================================================
        [HttpGet]
        [Route("RolesLista")]
        public IActionResult RolesLista() //FUNCIONAL, LLAMAR LA LISTA
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

        private string Encrypt(string texto) //FUNCIONAL 100%
        {
            byte[] iv = new byte[16];
            byte[] array;

            using (Aes aes = Aes.Create())
            {
                aes.Key = Encoding.UTF8.GetBytes(_conf.GetSection("Variables:Llave").Value!);
                aes.IV = iv;

                ICryptoTransform encryptor = aes.CreateEncryptor(aes.Key, aes.IV);

                using (MemoryStream memoryStream = new MemoryStream())
                {
                    using (CryptoStream cryptoStream = new CryptoStream(memoryStream, encryptor, CryptoStreamMode.Write))
                    {
                        using (StreamWriter streamWriter = new StreamWriter(cryptoStream))
                        {
                            streamWriter.Write(texto);
                        }

                        array = memoryStream.ToArray();
                    }
                }
            }

            return Convert.ToBase64String(array);
        }
    }
}
