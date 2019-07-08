class User < ActiveRecord::Base
  has_many :shows
  has_many :schedules, through: :shows

  def initialize(name, id=nil)
    @id = id
    @name = name
  end

end
