
namespace LyricsIdentity;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container.

        builder.Services.AddControllers();
        // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen();

        var app = builder.Build();

        // Configure the HTTP request pipeline.
        app.UseSwagger();
        app.UseSwaggerUI();

        app.Use(async (context, next) =>
        {
            var startTime = DateTimeOffset.UtcNow;

            await next();

            var elapsedMilliseconds = (DateTimeOffset.UtcNow - startTime).TotalMilliseconds;
            app.Logger.LogInformation(
                "{Method} {Path} responded {StatusCode} in {ElapsedMilliseconds:F0} ms",
                context.Request.Method,
                context.Request.Path,
                context.Response.StatusCode,
                elapsedMilliseconds);
        });

        app.UseHttpsRedirection();

        app.UseAuthorization();


        app.MapControllers();

        app.Run();
    }
}
