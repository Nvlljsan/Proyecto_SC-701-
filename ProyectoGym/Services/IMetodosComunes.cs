using ProyectoGym.Models;
using ProyectoGym.Models.ViewModels;

namespace ProyectoGym.Services
{
    public interface IMetodosComunes
    {
        string Encrypt(string texto);

        List<CarritoViewModel> CarritoLista();
    }
}
