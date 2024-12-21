using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using ProyectoGymAPI.Models;
using System.Data;
using static System.Net.WebRequestMethods;

namespace ProyectoGymAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CarritoController : ControllerBase
    {
        private readonly IConfiguration _conf;
        private readonly IHostEnvironment _env;

        public CarritoController(IConfiguration conf, IHostEnvironment env)
        {
            _conf = conf;
            _env = env;
        }

        [HttpGet("ObtenerCarrito/{UsuarioID}")]
       
        public IActionResult ObtenerCarrito(int UsuarioID)
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                var result = context.Query<CarritoViewModel>("CarritoObtener", new { UsuarioID });

                if (result.Any())
                {
                    respuesta.Codigo = 0;
                    respuesta.Contenido = result;
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "No hay productos en el carrito en este momento";
                }

                return Ok(respuesta);
            }

        }
        [HttpPost]
        [Route("AgregarAlCarrito")]
        public IActionResult AgregarAlCarrito(Carrito model)
        {
            Console.WriteLine($"UsuarioID: {model.UsuarioID}, ProductoID: {model.ProductoID}, Cantidad: {model.Cantidad}");

            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                try
                {
                    var result = context.Execute("CarritoAgregar", new { model.UsuarioID, model.ProductoID, model.Cantidad });

                    Console.WriteLine($"Resultado del SP: {result}");

                    if (result > 0)
                    {
                        respuesta.Codigo = 0;
                        respuesta.Mensaje = "Producto agregado al carrito.";
                    }
                    else
                    {
                        respuesta.Codigo = -1;
                        respuesta.Mensaje = "No se pudo agregar el producto al carrito.";
                    }
                }
                catch (SqlException ex)
                {
                    Console.WriteLine($"Error: {ex.Message}");
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = ex.Message;
                }

                return Ok(respuesta);
            }
        }



        [HttpDelete]
        [Route("EliminarProducto")]
        public IActionResult EliminarProducto(int carritoID) //SP FUNCIONA DESDE DB PERO NO HA SIDO PROBADO POR QUE NO HAY VISTA
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                try { 
                var result = context.Execute("CarritoEliminar", new { carritoID });

                    if (result > 0)
                    {
                        respuesta.Codigo = 0;
                        respuesta.Mensaje = "El stock del producto fue restaurado correctamente.";
                    }
                    else
                    {
                        respuesta.Codigo = -1;
                        respuesta.Mensaje = "No se pudo restaurar el stock.";
                    }
                }
                catch (SqlException ex)
                {
                    Console.WriteLine($"Error: {ex.Message}");
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = ex.Message;
                }

                return Ok(respuesta);
            }
        }
        [HttpPost]
        [Route("SimularPago")]
        public IActionResult SimularPago([FromBody] Usuarios usuario)
        {
            if (usuario == null || usuario.UsuarioID <= 0)
            {
                return BadRequest("El UsuarioID es inválido.");
            }

            Console.WriteLine($"UsuarioID recibido en la API: {usuario.UsuarioID}");

            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
                try
                {
                    var result = context.Execute("CarritoSimularPago", new { UsuarioID = usuario.UsuarioID }, commandType: CommandType.StoredProcedure);

                    respuesta.Codigo = 0;
                    respuesta.Mensaje = "Pago simulado correctamente. El carrito ha sido vaciado, y las ventas e historial registrados.";
                }
                catch (SqlException ex)
                {
                    Console.WriteLine($"Error: {ex.Message}");
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = ex.Message;
                }

                return Ok(respuesta);
            }
        }


        [HttpGet]
        [Route("HistorialCompras/{usuarioID}")]
        public IActionResult HistorialCompras(int usuarioID)
        {
            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                // Llama al procedimiento almacenado
                var historial = context.Query<HistorialCompraViewModel>(
                    "ObtenerHistorialCompras",
                    new { UsuarioID = usuarioID },
                    commandType: CommandType.StoredProcedure).ToList();

                return Ok(historial);
            }
        }

    }
}


