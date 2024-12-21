using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using ProyectoGymAPI.Models;
using System.Data;
using System.Net.Mail;
using System.Net;
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

        [HttpPost]
        [Route("InicioSesion")]
        public IActionResult InicioSesion(Usuarios model) //FUNCIONAL 100%
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var contrasenaCifrada = Encrypt(model.Contrasena); //Se encripta la contraseña que recibe

                var usuario = context.QueryFirstOrDefault<Usuarios>("InicioSesion", new {model.Email, Contrasena = contrasenaCifrada});

                if (usuario != null)
                {
                    respuesta.Codigo = 0;
                    respuesta.Contenido = usuario; 
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "Datos incorrectos o Usuario Inactivo.";
                }

                return Ok(respuesta);
            }
        }

        [HttpPost]
        [Route("Registro")]
        public IActionResult Registro(Usuarios model) //FUNCIONAL 100%
        {
            if (model.RolID == 0 || model.RolID == null)
            {
                model.RolID = 3;
            }

            model.Contrasena = Encrypt(model.Contrasena); //Se encripta la contraseña que recibe

            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
              //  var correoExistente = context.QueryFirstOrDefault<Usuarios>("Usuario", new { model.Email, model.Telefono });

                //if (correoExistente != null)
                //{
                //    return BadRequest(new
                //    {
                //        Codigo = -1,
                //        Mensaje = "El correo o telefono ya está registrado. Por favor, use uno diferente."
                //    });
                //}

                //if (model.Telefono.Length != 8 || !model.Telefono.All(char.IsDigit))
                //{
                //    return BadRequest(new
                //    {
                //        Codigo = -1,
                //        Mensaje = "El número de teléfono debe contener exactamente 8 dígitos y solo números."
                //    });
                //}

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

        [HttpPost]
        [Route("RecuperarAcceso")]
        public IActionResult RecuperarAcceso(Usuarios model) //FUNCIONAL 100%
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();

                var usuario = context.QueryFirstOrDefault<Usuarios>("UsuariosValidar", new { model.Email }); //Verificar que el Usuario exista

                if (usuario != null)
                {
                    var codigo = GenerarCodigo();
                    DateTime vigencia = DateTime.Now.AddMinutes(30);
                    var tokenCifrado = Encrypt(codigo);

                    context.Execute("TokenC", new { usuario.UsuarioID, Token = tokenCifrado, FechaExpiracion = vigencia }); //Crear un Token

                    var ruta = Path.Combine(_env.ContentRootPath, "Template", "RecuperarAcceso.html"); //Ruta con el mensaje del Correo
                    var html = System.IO.File.ReadAllText(ruta);

                    html = html.Replace("@@Nombre", usuario.Nombre);
                    html = html.Replace("@@Contrasenna", codigo);
                    html = html.Replace("@@Vencimiento", vigencia.ToString("dd/MM/yyyy hh:mm tt"));

                    EnviarCorreo(model.Email, "Recuperar Accesos Sistema", html); //Metodo de enviar correo

                    respuesta.Codigo = 0;
                    respuesta.Contenido = usuario;
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "Su información no se encontró en nuestro sistema";
                }

                return Ok(respuesta);
            }
        }

        [HttpPost]
        [Route("CambiarContrasena")]
        public IActionResult CambiarContrasena(Tokens model) //FUNCIONAL 100%
        {
            Console.WriteLine($"Token recibido: {model.Token}, Nueva Contraseña: {model.NuevaContrasena}");

            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var tokenCifrado = Encrypt(model.Token);

                var token = context.QueryFirstOrDefault<Usuarios>( "TokenValidar", new { Token = tokenCifrado });

                if (token != null)
                {
                    var contrasenaCifrada = Encrypt(model.NuevaContrasena);
                    var contrasena = context.Execute("ActualizarContrasena", new { token.UsuarioID, NuevaContrasena = contrasenaCifrada });

                    if (contrasena != null) //Diferente de null para confirmar que esta recibiendo una contraseña
                    {
                        var eliminar = context.Execute("TokenD", new { Token = tokenCifrado });

                        if (eliminar > 0)
                        {
                            respuesta.Codigo = 0;
                        }
                        else
                        {
                            respuesta.Codigo = -1;
                            respuesta.Mensaje = "Error al eliminar el token.";
                        }
                    }
                    else
                    {
                        respuesta.Codigo = -1;
                        respuesta.Mensaje = "Error al actualizar la contraseña.";
                    }
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "El token no es válido o ha expirado.";
                }

                return Ok(respuesta);
            }
        }


        //======================================================[Metodos Auxiliares]=====================================================================
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

        private string Decrypt(string texto) //FUNCIONAL 100%
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

        private void EnviarCorreo(string destino, string asunto, string contenido) //FUNCIONAL 100%
        {
            string cuenta = _conf.GetSection("Variables:CorreoEmail").Value!;
            string contrasenna = _conf.GetSection("Variables:ClaveEmail").Value!;

            MailMessage message = new MailMessage();
            message.From = new MailAddress(cuenta);
            message.To.Add(new MailAddress(destino));
            message.Subject = asunto;
            message.Body = contenido;
            message.Priority = MailPriority.Normal;
            message.IsBodyHtml = true;

            SmtpClient client = new SmtpClient("smtp.office365.com", 587);
            client.Credentials = new NetworkCredential(cuenta, contrasenna);
            client.EnableSsl = true;

            client.Send(message);            
        }

        private string GenerarCodigo() //FUNCIONAL 100%
        {
            int length = 8;
            const string valid = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            StringBuilder res = new StringBuilder();
            Random rnd = new Random();
            while (0 < length--)
            {
                res.Append(valid[rnd.Next(valid.Length)]);
            }
            return res.ToString();
        }

    }
}
