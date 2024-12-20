using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using ProyectoGymAPI.Models;
using System.Data;

namespace ProyectoGymAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CarritoController : ControllerBase
    {
        private readonly IConfiguration _conf;

        public CarritoController(IConfiguration conf)
        {
            _conf = conf;
        }

        [HttpPost]
        [Route("AgregarAlCarrito")]
        public IActionResult AgregarAlCarrito(Carrito model) //FUNCIONAL 100%
        {
            Console.WriteLine($"UsuarioID: {model.UsuarioID}, ProductoID: {model.ProductoID}, Cantidad: {model.Cantidad}");

            using (var context = new SqlConnection(_conf.GetSection("ConnectionStrings:DefaultConnection").Value))
            {
                var respuesta = new Respuesta();
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
                var result = context.Execute("CarritoEliminar", new { CarritoID = carritoID });

                if (result > 0)
                {
                    respuesta.Codigo = 0;
                    respuesta.Mensaje = "Producto eliminado del carrito correctamente.";
                }
                else
                {
                    respuesta.Codigo = -1;
                    respuesta.Mensaje = "No se pudo eliminar el producto del carrito.";
                }

                return Ok(respuesta);
            }
        }
    }
}
