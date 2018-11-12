using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Routing;
using Microsoft.AspNetCore.SpaServices.Webpack;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace HiveMind
{
	public class Startup
	{
		private readonly IHostingEnvironment _env;
		private readonly IConfiguration _config;
		private readonly ILoggerFactory _loggerFactory;

		public Startup(IHostingEnvironment env, IConfiguration config,
		  ILoggerFactory loggerFactory)
		{
			_env = env;
			_config = config;
			_loggerFactory = loggerFactory;
		}

		public void ConfigureServices(IServiceCollection services)
		{
			var logger = _loggerFactory.CreateLogger<Startup>();

			if (_env.IsDevelopment())
			{
				// Development service configuration
				logger.LogInformation("Development environment");
			}
			else
			{
				// Non-development service configuration
				logger.LogInformation($"Environment: {_env.EnvironmentName}");
			}

			// Add framework services
			services.AddMvc();
		}

		public void Configure(IApplicationBuilder application, IHostingEnvironment env)
		{
			application.UseMvc(routes =>
			{
				routes.MapRoute(
				name: "default",
				template: "{controller=Home}/{action=Index}/{id?}");

				routes.MapRoute(
					name: "blog",
					template: "{controller=BlogController}/{action=Blog}");
			});
		}
	}
}