using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using ProyectoGymAPI.Models;
using ProyectoGymAPI.Models.Requests;
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

        //Aun tengo que configurar bien el inicio de sesion
        [HttpPost]
        [Route("InicioSesion")]
        public IActionResult InicioSesion(Usuarios model)
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var contrasenaCifrada = Encrypt(model.Contrasena);

                var usuario = context.QueryFirstOrDefault<Usuarios>("InicioSesion", new {model.Email, Contrasena = contrasenaCifrada});

                if (usuario != null)
                {
                    respuesta.Codigo = 0;
                    respuesta.Contenido = usuario; // Usuario válido
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "Correo o contraseña incorrectos.";
                }

                return Ok(respuesta);
            }
        }

        [HttpPost]
        [Route("RecuperarAcceso")]
        public IActionResult RecuperarAcceso(Usuarios model)
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();

                var usuario = context.QueryFirstOrDefault<Usuarios>("SELECT * FROM Usuarios WHERE Email = @Email",
                    new { model.Email });

                if (usuario != null)
                {
                    string token = GenerarCodigo();
                    DateTime vigencia = DateTime.Now.AddMinutes(30);

                    context.Execute("INSERT INTO RecuperarTokens (UsuarioID, Token, FechaExpiracion) VALUES (@UsuarioID, @Token, @FechaExpiracion)",
                        new { usuarioID = usuario.UsuarioID, Token = Encrypt(token), FechaExpiracion = vigencia });

                    var ruta = Path.Combine(_env.ContentRootPath, "Template", "RecuperarAcceso.html");
                    var html = System.IO.File.ReadAllText(ruta);

                    html = html.Replace("@@Nombre", usuario.Nombre);
                    html = html.Replace("@@Contrasenna", token);
                    html = html.Replace("@@Vencimiento", vigencia.ToString("dd/MM/yyyy hh:mm tt"));

                    EnviarCorreo(model.Email, "Recuperar Accesos Sistema", html);

                    respuesta.Codigo = 0;
                    respuesta.Contenido = new { usuario.Nombre, TokenEnviado = true };
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
        [Route("RestablecerContrasena")]
        public IActionResult RestablecerContrasena(RestablecerRequest model)
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();

                var tokenInfo = context.QueryFirstOrDefault("SELECT * FROM RecuperarTokens WHERE Token = @Token AND FechaExpiracion > GETDATE()",
                    new { Token = Encrypt(model.Token) });

                if (tokenInfo != null)
                {
                    context.Execute("UPDATE Usuarios SET Contrasena = @NuevaContrasenna WHERE UsuarioID = @UsuarioID",
                        new { usuarioID = tokenInfo.UsuarioID, NuevaContrasenna = Encrypt(model.NuevaContrasena) });

                    context.Execute("DELETE FROM RecuperarTokens WHERE Token = @Token",
                        new { Token = Encrypt(model.Token) });

                    respuesta.Codigo = 0;
                    respuesta.Mensaje = "La contraseña se ha actualizado correctamente.";
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "El token no es válido o ha expirado.";
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

            model.Contrasena = Encrypt(model.Contrasena);

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
        private void EnviarCorreo(string destino, string asunto, string contenido)
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

        private string GenerarCodigo()
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
