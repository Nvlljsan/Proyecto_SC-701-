using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity.Data;
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
                    if (result.Contrasena == model.Contrasena)
                    {
                        respuesta.Codigo = 0;
                        respuesta.Contenido = result; // El usuario es válido
                    }
                    else
                    {
                        respuesta.Codigo = -1;
                        respuesta.Mensaje = "Contraseña incorrecta";
                    }
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
            if (model.RolID == 0 || model.RolID == null)
            {
                model.RolID = 3;
            }

            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
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

        //======================================================[Metodos Auxiliares]=====================================================================
        private string Encrypt(string texto)
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


        private string Decrypt(string texto)
        {
            byte[] iv = new byte[16];
            byte[] buffer = Convert.FromBase64String(texto);

            using (Aes aes = Aes.Create())
            {
                aes.Key = Encoding.UTF8.GetBytes(_conf.GetSection("Variables:Llave").Value!);
                aes.IV = iv;
                ICryptoTransform decryptor = aes.CreateDecryptor(aes.Key, aes.IV);

                using (MemoryStream memoryStream = new MemoryStream(buffer))
                {
                    using (CryptoStream cryptoStream = new CryptoStream(memoryStream, decryptor, CryptoStreamMode.Read))
                    {
                        using (StreamReader streamReader = new StreamReader(cryptoStream))
                        {
                            return streamReader.ReadToEnd();
                        }
                    }
                }
            }
        }
    }
}
