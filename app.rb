require("sinatra")
require("sinatra/reloader")
require("./lib/project")
require("./lib/volunteer")
require("pry")
also_reload("lib/**/*.rb")
require("pg")
require "dotenv/load"

DB = PG.connect({ :dbname => "volunteer_tracker", :user => "postgres", :password => ENV["PG_PASS"] })

get("/") do
  @projects = Project.all
  @volunteer = Volunteer.all
  erb(:homepage)
end

get("/project/:id") do
  @project = Project.find(:id)
  erb(:project)
end

get("/project/:id/edit") do
  @project = Project.find(:id)
  erb(:editproject)
end

post("/create_project") do
  entered_title = params[:title]
  newproject = Project.new({ :title => entered_title, :id => nil })
  newproject.save()
  redirect to ("/")
end

patch("/project/:id/edit") do
  newname = params[:title]
  @project = Project.find(:id)
  @project.update({ :title => newname, :id => nil })
  @project.save()
  redirect to ("/")
end
