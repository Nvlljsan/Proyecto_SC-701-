﻿using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using ProyectoGymAPI.Models;

namespace ProyectoGymAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductosController : ControllerBase
    {
        private readonly IConfiguration _conf;
        private readonly IHostEnvironment _env;

        public ProductosController(IConfiguration conf, IHostEnvironment env)
        {
            _conf = conf;
            _env = env;
        }

        [HttpGet]
        [Route("ProductosLista")]
        public IActionResult ProductosLista() //FUNCIONAL 100%
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var result = context.Query<Productos>("ProductosLista", new { });

                if (result != null)
                {
                    respuesta.Codigo = 0;
                    respuesta.Contenido = result;
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "No hay productos registrados en el sistema";
                }
                return Ok(respuesta);
            }
        }

        [HttpPost]
        [Route("ProductoC")]
        public IActionResult ProductoC(Productos model) //FUNCIONAL 100%
        {
            if (model.Precio <= 0)
            {
                return BadRequest(new Respuesta
                {
                    Codigo = -1,
                    Mensaje = "El precio debe ser mayor a 0."
                });
            }

            if (model.Stock < 0)
            {
                return BadRequest(new Respuesta
                {
                    Codigo = -1,
                    Mensaje = "El stock no puede ser menor a 0."
                });
            }

            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var result = context.Execute("ProductoC", new { model.NombreProducto, model.Descripcion, model.Precio, model.Stock, model.Imagen});

                if (result > 0)
                {
                    respuesta.Codigo = 0;
                    respuesta.Mensaje = "Producto registrado con éxito.";
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "Error al registrar un producto.";
                }

                return Ok(respuesta);
            }
        }

        [HttpGet]
        [Route("ProductoR")]
        public IActionResult ProductoR(int productoID) //PROBAR
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var result = context.QueryFirstOrDefault<Productos>("ProductoR", new { ProductoID = productoID });

                if (result != null)
                {
                    return Ok(result);
                }
                else
                {
                    return NotFound(new { Mensaje = "producto no encontrado." });
                }
            }
        }

        [HttpPut]
        [Route("ProductoU")]
        public IActionResult ProductoU(Productos model) //FUNCIONAL 100%
        {
            if (model.Precio <= 0)
            {
                return BadRequest(new Respuesta
                {
                    Codigo = -1,
                    Mensaje = "El precio debe ser mayor a 0."
                });
            }

            if (model.Stock < 0)
            {
                return BadRequest(new Respuesta
                {
                    Codigo = -1,
                    Mensaje = "El stock no puede ser menor a 0."
                });
            }

            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();

                var result = context.Execute("ProductoU", new { model.ProductoID, model.NombreProducto, model.Descripcion, model.Precio, model.Stock, model.Imagen});

                if (result > 0)
                {
                    respuesta.Codigo = 0;
                    respuesta.Mensaje = "Producto actualizado con éxito.";
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "Error al actualizar el producto.";
                }
                return Ok(respuesta);
            }
        }

        [HttpDelete]
        [Route("ProductoD")]
        public IActionResult ProductoD(int productoID) //FUNCIONAL 100%
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var result = context.Execute("ProductoD", new { ProductoID = productoID });

                if (result > 0)
                {
                    respuesta.Codigo = 0;
                    respuesta.Mensaje = "Producto eliminado con éxito.";
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "Error al eliminar el producto.";
                }
                return Ok(respuesta);
            }
        }

        [HttpGet]
        [Route("ProductosCatalogo")]
        public IActionResult ProductosCatalogo() //FUNCIONAL 100%
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var result = context.Query<Productos>("ProductosCatalogo", new { });

                if (result != null)
                {
                    respuesta.Codigo = 0;
                    respuesta.Contenido = result;
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "No hay productos registrados en el sistema";
                }
                return Ok(respuesta);
            }
        }
    }
}
