class User < ActiveRecord::Base
  has_many :schedules
  has_many :shows, through: :schedules

  def initialize(name, id=nil)
    @id = id
    @name = name
  end

end
