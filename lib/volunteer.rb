class Volunteer
  attr_accessor(:name, :project_id)
  attr_reader(:id)

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch (:id)
    @project_id = attributes.fetch(:project_id)
  end

  def ==(volunteer_to_compare)
    self.name() == volunteer_to_compare.name()
  end

  def save
    entry = DB.exec("INSERT INTO volunteers (name) values ('#{@name}') RETURNING id")
    @id = entry.first().fetch("id").to_i
  end

  def self.all
    all_volunteers = DB.exec("SELECT * FROM volunteers")
    volunteers = []
    all_volunteers.each() do |entry|
      name = entry.fetch("name")
      project_id = entry.fetch("project_id")
      id = entry.fetch("id").to_i
      volunteers.push(Volunteer.new({ :name => name, :project_id => project_id, :id => id }))
    end
    volunteers
  end
end
