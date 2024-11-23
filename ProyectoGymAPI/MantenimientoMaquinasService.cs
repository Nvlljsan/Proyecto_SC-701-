using ProyectoGymAPI.Model;

namespace ProyectoGymAPI.Services
{
    public class MantenimientoMaquinasService : IMantenimientoMaquinasService
    {
        private readonly List<MantenimientoMaquinas> _mantenimientos = new List<MantenimientoMaquinas>();

        public IEnumerable<MantenimientoMaquinas> GetMantenimientos()
        {
            return _mantenimientos;
        }

        public MantenimientoMaquinas GetMantenimientoById(int id)
        {
            return _mantenimientos.FirstOrDefault(m => m.MantenimientoID == id);
        }

        public void AddMantenimiento(MantenimientoMaquinas mantenimiento)
        {
            _mantenimientos.Add(mantenimiento);
        }

        public bool UpdateMantenimiento(MantenimientoMaquinas mantenimiento)
        {
            var existingMantenimiento = GetMantenimientoById(mantenimiento.MantenimientoID);
            if (existingMantenimiento == null)
                return false;

            existingMantenimiento.EmpleadoID = mantenimiento.EmpleadoID;
            existingMantenimiento.MaquinaID = mantenimiento.MaquinaID;
            existingMantenimiento.FechaMantenimiento = mantenimiento.FechaMantenimiento;
            existingMantenimiento.Descripcion = mantenimiento.Descripcion;

            return true;
        }

        public bool DeleteMantenimiento(int id)
        {
            var mantenimiento = GetMantenimientoById(id);
            if (mantenimiento == null)
                return false;

            _mantenimientos.Remove(mantenimiento);
            return true;
        }
    }
}
