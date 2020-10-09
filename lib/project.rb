require "spec_helper"

class Project
  attr_accessor(:title)
  attr_reader(:id)

  def initialize(attributes)
    @title = attributes.fetch(:title)
    @id = attributes.fetch(:id)
  end

  def ==(project_to_compare)
    self.title() == project_to_compare.title()
  end

  def save
    entry = DB.exec("INSERT INTO projects (title) values ('#{@title}') RETURNING id")
    @id = entry.first().fetch("id").to_i
  end

  def delete
    entry = DB.exec("DELETE from projects WHERE id = #{@id}")
  end

  def self.all
    all_projects = DB.exec("SELECT * FROM projects")
    projects = []
    all_projects.each() do |entry|
      title = entry.fetch("title")
      id = entry.fetch("id").to_i
      projects.push(Project.new({ :title => title, :id => id }))
    end
    projects
  end

  def self.find(id)
    selected_project = DB.exec("SELECT * FROM projects WHERE id = #{id};").first
    if selected_project
      title = selected_project.fetch("title")
      id = selected_project.fetch("id")
      Project.new({ :title => title, :id => id })
    else
      nil
    end
  end

  def update(attributes)
    @title = attributes.fetch(:title)
    title_entry = DB.exec("UPDATE projects SET title ='#{@title}' ;")
  end

  def volunteers
    volunteers = []
    project_volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{@id};")
    project_volunteers.each do |entry|
      id = entry.fetch("id").to_i
      volunteer = DB.exec("SELECT * FROM volunteers WHERE id = #{id}")
      name = entry.fetch("name")
      project_id = entry.fetch("project_id")
      volunteers.push(Volunteer.new({ :name => name, :id => id, :project_id => project_id }))
    end
    volunteers
  end
end
