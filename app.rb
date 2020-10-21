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
  erb(:projects)
end

get("/projects/:id") do
  id = params[:id].to_i
  @project = Project.find(id)
  @volunteers = @project.volunteers()
  erb(:project)
end

get("/projects/:id/edit") do
  id = params[:id].to_i
  @project = Project.find(id)
  @volunteers = @project.volunteers()
  erb(:editproject)
end

post("/projects") do
  entered_title = params[:title]
  newproject = Project.new({ :title => entered_title, :id => nil })
  newproject.save()
  redirect to ("/")
end

delete("/projects/:id") do
  id = params[:id]
  @project = Project.find(id)
  @project.delete()
  @projects = Project.all
  erb(:projects)
end

patch("/projects/:id") do
  newname = params[:title]
  @project = Project.find(:id)
  @project.update({ :title => newname, :id => nil })
  @project.save()
  redirect to ("/")
end

post("/projects/:id/volunteers") do
  name = params[:name]
  projectid = params[:id].to_i
  name = params[:volunteername]
  enteredvolunteer = Volunteer.new({ :name => name, :project_id => projectid, :id => nil })
  enteredvolunteer.save()
  @projects = Project.all
  @project = Project.find(projectid)
  erb(:projects)
end

get("/projects/:id/volunteers/:volunteerid") do
  id = params[:id].to_i
  volunteerid = params[:volunteerid].to_i
  @project = Project.find(id)
  @volunteer = Volunteer.find(volunteerid)
  erb(:volunteer)
end

patch("/projects/:id/volunteers/:volunteerid") do
  id = params[:id].to_i
  volunteerid = params[:volunteerid].to_i
  newname = params[:name]
  @volunteer = Volunteer.find(volunteerid)
  @volunteer.update({ :name => newname, :id => nil })
  @volunteer.save()
  erb(:volunteer)
end

delete("/projects/:id/volunteers/:volunteerid") do
  id = params[:id].to_i
  volunteerid = params[:volunteerid].to_i
  @volunteer = Volunteer.find(volunteerid)
  @volunteer.delete()
  @volunteers = Volunteer.all
  erb(:projects)
end
