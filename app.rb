require("sinatra")
require("sinatra/reloader")
require("./lib/project")
require("./lib/volunteer")
require("pry")
also_reload("lib/**/*.rb")
require("pg")
require "dotenv/load"

DB = PG.connect({ :dbname => "volunteer_tracker", :user => ENV.fetch("PGUSER"), :password => ENV.fetch("PGPASS") })

get("/") do
  @projects = Project.all
  @volunteer = Volunteer.all
  erb(:homepage)
end

get("/projects/:id") do
  @project = Project.find(:id)
  erb(:project)
end

get("/projects/:id/edit") do
  @project = Project.find(:id)
  erb(:editproject)
end

post("/create_project") do
  entered_title = params[:title]
  newproject = Project.new({ :title => entered_title, :id => nil })
  newproject.save()
  redirect to ("/")
end

delete("/projects/:id/edit") do
  id = params[:id]
  @project = Project.find(id)
  @project.delete()
  @projects = Project.all
  erb(:homepage)
end

patch("/projects/:id/edit") do
  newname = params[:title]
  @project = Project.find(:id)
  @project.update({ :title => newname, :id => nil })
  @project.save()
  redirect to ("/")
end

post("/volunteers") do
  name = params[:name]
  projectid = params[:projectid]
  name = params[:volunteername]
  enteredvolunteer = Volunteer.new({ :name => name, :project_id => projectid, :id => nil })
  enteredvolunteer.save()
end
