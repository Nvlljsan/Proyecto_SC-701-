using ProyectoGym.Models.ViewModels;
using ProyectoGym.Models;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using static System.Net.WebRequestMethods;
using System.Text.Json;


namespace ProyectoGym.Services
{
    public class MetodosComunes : IMetodosComunes
    {
        private readonly IConfiguration _conf;
        private readonly IHttpClientFactory _http;
        private readonly IHttpContextAccessor _accesor;
        public MetodosComunes(IConfiguration conf, IHttpClientFactory http, IHttpContextAccessor accesor)
        {
            _conf = conf;
            _http = http;
            _accesor = accesor;
        }

        public string Encrypt(string texto)
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


        public string Decrypt(string texto)
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

        public List<CarritoViewModel> CarritoLista()
        {
           
            var consecutivo = long.Parse(_accesor.HttpContext?.User.FindFirstValue(ClaimTypes.NameIdentifier)!.ToString());

            using (var client = _http.CreateClient())
            {
             
                var url = _conf.GetSection("Variables:UrlApi").Value + "Carrito/ObtenerCarrito/" + consecutivo;


                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    var datosContenido = JsonSerializer.Deserialize<List<CarritoViewModel>>((JsonElement)result.Contenido!);
                    return datosContenido!.ToList();
                }

                return new List<CarritoViewModel>();
            }
        }
    }
}
