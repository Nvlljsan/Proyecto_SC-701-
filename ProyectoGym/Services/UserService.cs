using ProyectoGym.Models;

namespace ProyectoGym.Services
{
    public interface IUserService
    {
        void RegisterUser(RegisterViewModel model);
    }

    public class UserService : IUserService
    {
        private readonly ApplicationDbContext _context;

        public UserService(ApplicationDbContext context)
        {
            _context = context;
        }

        public void RegisterUser(RegisterViewModel model)
        {
            var user = new ApplicationUser
            {
                UserName = model.Username,
                Email = model.Email
            };

            _context.Users.Add(user);
            _context.SaveChanges();
        }
    }
}
