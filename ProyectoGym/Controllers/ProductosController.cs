﻿using Microsoft.AspNetCore.Mvc;
using ProyectoGym.Models;
using ProyectoGym.Services;
using System.Net.Http.Headers;
using System.Text.Json;

namespace ProyectoGym.Controllers
{
    public class ProductosController : Controller
    {
        private readonly IHttpClientFactory _http;
        private readonly IConfiguration _conf;
        private readonly IMetodosComunes _comunes;
        private readonly IHostEnvironment _env;

        public ProductosController(IHttpClientFactory http, IConfiguration conf, IMetodosComunes comunes, IHostEnvironment env)
        {
            _http = http;
            _conf = conf;
            _comunes = comunes;
            _env = env;
        }

        [HttpGet]
        public IActionResult ProductosLista() //FUNCIONAL 100%
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Productos/ProductosLista";

                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    var datosContenido = JsonSerializer.Deserialize<List<Productos>>((JsonElement)result.Contenido!);
                    return View(datosContenido);
                }

                return View(new List<Productos>());
            }
        }

        [HttpGet]
        public IActionResult ProductoC() //FUNCIONAL 100%
        {
            return View();
        }

        [HttpPost]
        public IActionResult ProductoC(IFormFile Imagen, Productos model) //FUNCIONAL 100%
        {
            var ext = string.Empty;
            var folder = string.Empty;

            if (Imagen != null)
            {
                ext = Path.GetExtension(Path.GetFileName(Imagen.FileName));
                folder = Path.Combine(_env.ContentRootPath, "wwwroot\\products");
                model.Imagen = "/products/" + Imagen.FileName;

                if (ext.ToLower() != ".png")
                {
                    ViewBag.Mensaje = "La imagen debe ser .png";
                    return View();
                }
            }
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Productos/ProductoC";

                JsonContent datos = JsonContent.Create(model);

                var response = client.PostAsync(url, datos).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    if (Imagen != null)
                    {
                        var archivo = Path.Combine(folder, result.Mensaje + ext);
                        using (Stream fs = new FileStream(archivo, FileMode.Create))
                        {
                            Imagen.CopyTo(fs);
                        }
                    }

                    return RedirectToAction("ProductosLista", "Productos");
                }
                else
                {
                    ViewBag.Mensaje = result!.Mensaje;
                    return View();
                }
            }
        }

        [HttpGet]
        public IActionResult ProductoU(int ProductoID) //FUNCIONAL 100%
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + $"Productos/ProductoR?productoID={ProductoID}";

                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Productos>().Result;

                if (result != null)
                {
                    return View(result);
                }
                else
                {
                    ViewBag.Mensaje = "No se encontraron datos del producto.";
                    return RedirectToAction("ProductosLista");
                }
            }
        }

        [HttpPost]
        public IActionResult ProductoU(Productos model) //FUNCIONAL 100%
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Productos/ProductoU";

                JsonContent datos = JsonContent.Create(model);

                var response = client.PutAsync(url, datos).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    return RedirectToAction("ProductosLista");
                }
                else
                {
                    ViewBag.Mensaje = result!.Mensaje;
                    return View(model);
                }
            }
        }

        [HttpPost]
        public IActionResult ProductoD(int productoID) //FUNCIONAL 100%
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Productos/ProductoD?productoID=" + productoID;

                var response = client.DeleteAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    return RedirectToAction("ProductosLista");
                }
                else
                {
                    ViewBag.Mensaje = result?.Mensaje ?? "Error desconocido";
                    return RedirectToAction("ProductosLista");
                }
            }
        }

        [HttpGet]
        public IActionResult CatalogoProductos() //FUNCIONAL 100%
        {
            using (var client = _http.CreateClient())
            {
                var url = _conf.GetSection("Variables:UrlApi").Value + "Productos/ProductosCatalogo";

                var response = client.GetAsync(url).Result;
                var result = response.Content.ReadFromJsonAsync<Respuesta>().Result;

                if (result != null && result.Codigo == 0)
                {
                    var datosContenido = JsonSerializer.Deserialize<List<Productos>>((JsonElement)result.Contenido!);
                    var productosFiltrados = datosContenido?.Where(p => p.Stock > 0).ToList();
                    return View(productosFiltrados);
                }

                return View(new List<Productos>());
            }
        }
    }
}
