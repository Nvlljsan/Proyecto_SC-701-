using Microsoft.AspNetCore.Authentication.Cookies;
using ProyectoGym.Services;
using QuestPDF.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();

builder.Services.AddHttpClient("DefaultClient", client => { client.Timeout = TimeSpan.FromMinutes(5); });

builder.Services.AddSession();

builder.Services.AddScoped<IMetodosComunes, MetodosComunes>();

builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme).AddCookie(options =>
{
    options.LoginPath = "/Login/InicioSesion";
    options.ExpireTimeSpan = TimeSpan.FromMinutes(20);
});

QuestPDF.Settings.License = LicenseType.Community;

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}


app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
app.UseSession();
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Login}/{action=InicioSesion}/{id?}");

app.Run();
