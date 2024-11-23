using ProyectoGymAPI.Model;

namespace ProyectoGymAPI.Services
{
    public interface IMantenimientoMaquinasService
    {
        IEnumerable<MantenimientoMaquinas> GetMantenimientos();
        MantenimientoMaquinas GetMantenimientoById(int id);
        void AddMantenimiento(MantenimientoMaquinas mantenimiento);
        bool UpdateMantenimiento(MantenimientoMaquinas mantenimiento);
        bool DeleteMantenimiento(int id);
    }
}
