using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using ProyectoGymAPI.Model;
using ProyectoGymAPI.Models;
using System.Data;

namespace ProyectoGymAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class InstructoresController : ControllerBase
    {
        private readonly IConfiguration _conf;

        public InstructoresController(IConfiguration conf)
        {
            _conf = conf;
        }


        [HttpGet]
        public IActionResult ObtenerInstructores()
        {
            using (var connection = new SqlConnection(_conf.GetConnectionString("DefaultConnection")))
            {
                try
                {
                    var instructores = connection.Query<Instructores>(
                        "ObtenerInstructores",
                        commandType: CommandType.StoredProcedure
                    ).ToList();

                    if (instructores.Any())
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = 0,
                            Contenido = instructores
                        });
                    }
                    else
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = -1,
                            Mensaje = "No se encontraron instructores registrados."
                        });
                    }
                }
                catch (Exception ex)
                {
                    return StatusCode(500, new Respuesta
                    {
                        Codigo = -1,
                        Mensaje = $"Error al consultar instructores: {ex.Message}"
                    });
                }
            }
        }

        [HttpPut]
        [Route("ModificarInstructor")]
        public IActionResult ModificarInstructor(Instructores model)
        {
            using (var connection = new SqlConnection(_conf.GetConnectionString("DefaultConnection")))
            {
                try
                {
                    var result = connection.Execute(
                        "ModificarInstructor",
                        new
                        {
                            model.InstructorID,
                            model.Especialidad,
                            model.ExperienciaAnios
                        },
                        commandType: CommandType.StoredProcedure
                    );

                    if (result > 0)
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = 0,
                            Mensaje = "Instructor modificado correctamente."
                        });
                    }
                    else
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = -1,
                            Mensaje = "No se pudo modificar el instructor."
                        });
                    }
                }
                catch (Exception ex)
                {
                    return StatusCode(500, new Respuesta
                    {
                        Codigo = -1,
                        Mensaje = $"Error al modificar instructor: {ex.Message}"
                    });
                }
            }
        }


        [HttpGet]
        [Route("ConsultarInstructores")]
        public IActionResult ConsultarInstructores()
        {
            using (var connection = new SqlConnection(_conf.GetConnectionString("DefaultConnection")))
            {
                try
                {
                    var instructores = connection.Query<Instructores>(
                        "ObtenerInstructores",
                        commandType: System.Data.CommandType.StoredProcedure).ToList();

                    if (instructores.Any())
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = 0,
                            Contenido = instructores
                        });
                    }
                    else
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = -1,
                            Mensaje = "No se encontraron instructores registrados."
                        });
                    }
                }
                catch (Exception ex)
                {
                    return StatusCode(500, new Respuesta
                    {
                        Codigo = -1,
                        Mensaje = $"Error al consultar instructores: {ex.Message}"
                    });
                }
            }
        }

        [HttpGet]
        [Route("ObtenerInstructoresConDetalle")]
        public IActionResult ObtenerInstructoresConDetalle()
        {
            using (var connection = new SqlConnection(_conf.GetConnectionString("DefaultConnection")))
            {
                try
                {
                    var instructores = connection.Query<Instructores>(
                        "ObtenerInstructoresConDetalle",
                        commandType: CommandType.StoredProcedure).ToList();

                    if (instructores.Any())
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = 0,
                            Contenido = instructores
                        });
                    }
                    else
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = -1,
                            Mensaje = "No se encontraron instructores registrados."
                        });
                    }
                }
                catch (Exception ex)
                {
                    return StatusCode(500, new Respuesta
                    {
                        Codigo = -1,
                        Mensaje = $"Error al consultar instructores: {ex.Message}"
                    });
                }
            }
        }

        [HttpGet]
        [Route("ObtenerUsuariosRol2")]
        public IActionResult ObtenerUsuariosRol2()
        {
            using (var connection = new SqlConnection(_conf.GetConnectionString("DefaultConnection")))
            {
                try
                {
                    var usuarios = connection.Query<Usuarios>(
                        "ObtenerUsuariosRol2",
                        commandType: CommandType.StoredProcedure).ToList();

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
                            Mensaje = "No se encontraron usuarios con RolID = 2."
                        });
                    }
                }
                catch (Exception ex)
                {
                    return StatusCode(500, new Respuesta
                    {
                        Codigo = -1,
                        Mensaje = $"Error al consultar usuarios con RolID = 2: {ex.Message}"
                    });
                }
            }
        }

        [HttpPost]
        [Route("AgregarInstructor")]
        public IActionResult AgregarInstructor(Instructores model)
        {
            using (var connection = new SqlConnection(_conf.GetConnectionString("DefaultConnection")))
            {
                try
                {
                    var existe = connection.ExecuteScalar<bool>(
                        "SELECT COUNT(1) FROM Instructores WHERE UsuarioID = @UsuarioID",
                        new { model.UsuarioID }
                    );

                    if (existe)
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = -1,
                            Mensaje = "El UsuarioID ya está asignado como instructor."
                        });
                    }
                    var resultado = connection.ExecuteScalar<int>(
                        "AgregarInstructor",
                        new
                        {
                            model.UsuarioID,
                            model.Especialidad,
                            model.ExperienciaAnios
                        },
                        commandType: CommandType.StoredProcedure
                    );

                    return Ok(new Respuesta
                    {
                        Codigo = 0,
                        Mensaje = "Instructor agregado correctamente.",
                        Contenido = resultado
                    });
                }
                catch (Exception ex)
                {
                    return StatusCode(500, new Respuesta
                    {
                        Codigo = -1,
                        Mensaje = $"Error al agregar instructor: {ex.Message}"
                    });
                }
            }
        }



        [HttpGet]
        [Route("ConsultarUsuariosRol2")]
        public IActionResult ConsultarUsuariosRol2()
        {
            using (var connection = new SqlConnection(_conf.GetConnectionString("DefaultConnection")))
            {
                try
                {
                    var usuarios = connection.Query<Usuarios>(
                        "ObtenerUsuariosRol2",
                        commandType: CommandType.StoredProcedure).ToList();

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
                            Mensaje = "No se encontraron usuarios con RolID = 2."
                        });
                    }
                }
                catch (Exception ex)
                {
                    return StatusCode(500, new Respuesta
                    {
                        Codigo = -1,
                        Mensaje = $"Error al consultar usuarios con RolID = 2: {ex.Message}"
                    });
                }
            }
        }

        [HttpGet]
        [Route("ObtenerInstructorPorID")]
        public IActionResult ObtenerInstructorPorID(int id)
        {
            using (var connection = new SqlConnection(_conf.GetConnectionString("DefaultConnection")))
            {
                try
                {
                    var instructor = connection.QueryFirstOrDefault<Instructores>(
                        "ObtenerInstructorPorID",
                        new { InstructorID = id },
                        commandType: CommandType.StoredProcedure
                    );

                    if (instructor != null)
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = 0,
                            Contenido = instructor
                        });
                    }
                    else
                    {
                        return Ok(new Respuesta
                        {
                            Codigo = -1,
                            Mensaje = "Instructor no encontrado."
                        });
                    }
                }
                catch (Exception ex)
                {
                    return StatusCode(500, new Respuesta
                    {
                        Codigo = -1,
                        Mensaje = $"Error al consultar instructor: {ex.Message}"
                    });
                }
            }
        }


    }
}