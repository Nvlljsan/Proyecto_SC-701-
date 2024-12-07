using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;
using Dapper;
using ProyectoGymAPI.Model;
using System.Data;
using ProyectoGymAPI.Models;

namespace ProyectoGymApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmpleadosController : ControllerBase
    {
        private readonly IConfiguration _conf;

        public EmpleadosController(IConfiguration configuration)
        {
            _conf = configuration;
        }

        private SqlConnection GetConnection()
        {
            return new SqlConnection(_conf.GetConnectionString("DefaultConnection"));
        }

        [HttpGet]
        public async Task<IActionResult> GetEmpleados()
        {
            using (var connection = GetConnection())
            {
                var empleados = await connection.QueryAsync(
                    "sp_GetEmpleados",
                    commandType: System.Data.CommandType.StoredProcedure);
                return Ok(empleados);
            }
        }

        [HttpPost]
        [Route("AgregarEmpleado")]
        public IActionResult AgregarEmpleado(Empleados model)
        {
            using (var connection = new SqlConnection(_conf.GetConnectionString("DefaultConnection")))
            {
                try
                {
                    var existe = connection.ExecuteScalar<bool>(
                        "SELECT COUNT(1) FROM Empleados WHERE UsuarioID = @UsuarioID",
                        new { model.UsuarioID }
                    );

                    if (existe)
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = -1,
                            Mensaje = "El UsuarioID ya está asignado como empleado."
                        });
                    }
                    var result = connection.Execute(
                        "AgregarEmpleado",
                        new
                        {
                            model.UsuarioID,
                            model.Puesto,
                            model.FechaContratacion
                        },
                        commandType: CommandType.StoredProcedure
                    );

                    if (result > 0)
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = 0,
                            Mensaje = "Empleado agregado correctamente."
                        });
                    }
                    else
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = -1,
                            Mensaje = "No se pudo agregar el empleado."
                        });
                    }
                }
                catch (Exception ex)
                {
                    return StatusCode(500, new Respuesta
                    {
                        Codigo = -1,
                        Mensaje = $"Error al agregar empleado: {ex.Message}"
                    });
                }
            }
        }


        [HttpPut]
        [Route("ModificarEmpleado")]
        public IActionResult ModificarEmpleado(Empleados model)
        {
            using (var connection = new SqlConnection(_conf.GetConnectionString("DefaultConnection")))
            {
                try
                {
                    var result = connection.Execute(
                        "ModificarEmpleado",
                        new
                        {
                            model.EmpleadoID,
                            model.Puesto,
                            model.FechaContratacion
                        },
                        commandType: CommandType.StoredProcedure
                    );

                    if (result > 0)
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = 0,
                            Mensaje = "Empleado modificado correctamente."
                        });
                    }
                    else
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = -1,
                            Mensaje = "No se pudo modificar el empleado."
                        });
                    }
                }
                catch (Exception ex)
                {
                    return StatusCode(500, new Respuesta
                    {
                        Codigo = -1,
                        Mensaje = $"Error al modificar empleado: {ex.Message}"
                    });
                }
            }
        }

        [HttpGet]
        [Route("ObtenerUsuariosParaEmpleados")]
        public IActionResult ObtenerUsuariosParaEmpleados()
        {
            using (var connection = new SqlConnection(_conf.GetConnectionString("DefaultConnection")))
            {
                try
                {
                    var usuarios = connection.Query<Usuarios>(
                        "ObtenerUsuariosParaEmpleados",
                        commandType: CommandType.StoredProcedure
                    ).ToList();

                    if (usuarios.Any())
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = 0,
                            Contenido = usuarios
                        });
                    }
                    else
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = -1,
                            Mensaje = "No hay usuarios disponibles para empleados."
                        });
                    }
                }
                catch (Exception ex)
                {
                    return StatusCode(500, new Respuesta
                    {
                        Codigo = -1,
                        Mensaje = $"Error al consultar usuarios: {ex.Message}"
                    });
                }
            }
        }

        [HttpGet]
        [Route("ObtenerEmpleadoPorID")]
        public IActionResult ObtenerEmpleadoPorID(int id)
        {
            using (var connection = new SqlConnection(_conf.GetConnectionString("DefaultConnection")))
            {
                try
                {
                    var empleado = connection.QueryFirstOrDefault<Empleados>(
                        "ObtenerEmpleadoPorID",
                        new { EmpleadoID = id },
                        commandType: CommandType.StoredProcedure
                    );

                    if (empleado != null)
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = 0,
                            Contenido = empleado
                        });
                    }
                    else
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = -1,
                            Mensaje = "No se encontró el empleado especificado."
                        });
                    }
                }
                catch (Exception ex)
                {
                    return StatusCode(500, new Respuesta
                    {
                        Codigo = -1,
                        Mensaje = $"Error al consultar empleado: {ex.Message}"
                    });
                }
            }
        }

    }
}
