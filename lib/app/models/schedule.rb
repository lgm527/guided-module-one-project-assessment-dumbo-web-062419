class Schedule < ActiveRecord::Base
  belongs_to :user
  belongs_to :show

  def initialize(user, show, id=nil)
    @id = id
    @user = user_id
    @show = show_id
  end

end
