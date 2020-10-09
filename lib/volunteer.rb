class Volunteer
  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch (:id)
    @project_id = attributes.fetch(:project_id)
  end
end
