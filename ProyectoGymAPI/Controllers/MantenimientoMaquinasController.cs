using Microsoft.AspNetCore.Mvc;
using ProyectoGymAPI.Model;
using ProyectoGymAPI.Models;
using ProyectoGymAPI.Services;
namespace ProyectoGymAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MantenimientoMaquinasController : ControllerBase
    {
        private readonly IMantenimientoMaquinasService _mantenimientoService;
        public MantenimientoMaquinasController(IMantenimientoMaquinasService mantenimientoService)
        {
            _mantenimientoService = mantenimientoService;
        }
        [HttpGet]
        public ActionResult<IEnumerable<MantenimientoMaquinas>> GetMantenimientos()
        {
            return Ok(_mantenimientoService.GetMantenimientos());
        }
        [HttpGet("{id}")]
        public ActionResult<MantenimientoMaquinas> GetMantenimientoById(int id)
        {
            var mantenimiento = _mantenimientoService.GetMantenimientoById(id);
            if (mantenimiento == null)
                return NotFound();
            return Ok(mantenimiento);
        }
        [HttpPost]
        public ActionResult<MantenimientoMaquinas> AddMantenimiento(MantenimientoMaquinas mantenimiento)
        {
            _mantenimientoService.AddMantenimiento(mantenimiento);
            return CreatedAtAction(nameof(GetMantenimientoById), new { id = mantenimiento.MantenimientoID }, mantenimiento);
        }
        [HttpPut("{id}")]
        public IActionResult UpdateMantenimiento(int id, MantenimientoMaquinas mantenimiento)
        {
            if (id != mantenimiento.MantenimientoID)
                return BadRequest();
            var result = _mantenimientoService.UpdateMantenimiento(mantenimiento);
            if (!result)
                return NotFound();
            return NoContent();
        }
        [HttpDelete("{id}")]
        public IActionResult DeleteMantenimiento(int id)
        {
            var result = _mantenimientoService.DeleteMantenimiento(id);
            if (!result)
                return NotFound();
            return NoContent();
        }
    }
}