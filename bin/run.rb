require_relative '../config/environment'
require 'pry'
require 'json'
require 'tty-prompt'


#Greeting

#prompt: create user or use existing

#new user: enters name User.new -> create schedule

#Existing user: new schedule, view schedule, edit schedule, or delete schedule

#New schedule gives a prompt to pick between artists playing at a certain time. Once you pick your artists for each conflicting time frame it creates a new schedule

class CommandLineInterface

  def initialize
    @prompt = TTY::Prompt.new
  end

  def greet_user
    puts 'Welcome to Bamchellaroo Man!'
    @prompt.select("Is this your first festival?") do |menu|
        menu.choice 'new user', -> { create_user }
        menu.choice 'use existing'
        end
    end

    def create_user
        user_login = @prompt.ask('What is your name?')
        current_user = User.new(user_login) 
        puts "Welcome to the party #{user_login}!"
        menu_choices(current_user)
    end

    def menu_choices(current_user)
        @prompt.select("What would you like to do?") do |menu|
            menu.choice 'create new schedule', -> scheduler
            menu.choice 'view an existing schedule'
            menu.choice 'update a schedule'
            menu.choice 'delete a schedule'
        end
    end

    def scheduler
        @prompt.select("Who are you excited to see today?") do |menu|
            menu.choice 'artist name, 12:00', -> Schedule.new(self.id, show.id)
        #     menu.choice 'artist name, 12:00', -> schedules << Schedule.new(self.id, show.id)
        #     menu.choice 'artist name, 12:00', -> schedules << Schedule.new(self.id, show.id)
        # end
    end



end


cli = CommandLineInterface.new
cli.greet_user
