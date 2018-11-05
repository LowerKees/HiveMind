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
			services.AddMvcCore();
		}

		public void Configure(IApplicationBuilder application, IHostingEnvironment env)
		{
			application.UseDirectoryBrowser();

			application.UseMvc(routes =>
			{
				routes.MapRoute(
			name: "default",
			template: "{controller=HomeController}/{action=Index}/{id?}");
			});
		}
	}
}