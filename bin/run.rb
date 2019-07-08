require_relative '../config/environment'


#Greeting

#prompt: create user or use existing

#new user: enters name User.new -> create schedule

#Existing user: new schedule, view schedule, edit schedule, or delete schedule

#New schedule gives a prompt to pick between artists playing at a certain time. Once you pick your artists for each conflicting time frame it creates a new schedule

class CommandLineInterface

  def initialize
    @prompt = TTY::Prompt.new
  end


end

cli = CommandLineInterface.new
