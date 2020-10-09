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
end
