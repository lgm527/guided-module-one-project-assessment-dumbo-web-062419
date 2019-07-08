class Show < ActiveRecord::Base
  has_many :schedules
  has_many :users, through: :schedules

  def initialize(artist, time, id=nil)
    @id = id
    @artist = artist
    @time = time
  end

end
