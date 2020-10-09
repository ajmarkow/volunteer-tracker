require("sinatra")
require("sinatra/reloader")
require("./lib/project")
require("./lib/volunteer")
require("pry")
also_reload("lib/**/*.rb")
require("pg")
require "dotenv/load"

DB = PG.connect({ :dbname => "volunteer_tracker", :password => ENV["PG_PASS"] })
