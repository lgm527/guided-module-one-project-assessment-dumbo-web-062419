class Schedule < ActiveRecord::Base

  belongs_to :show
  belongs_to :user

  # def initialize(user, show, id=nil)
  #   @id = id
  #   @user = user_id
  #   @show = show_id
  # end

end
