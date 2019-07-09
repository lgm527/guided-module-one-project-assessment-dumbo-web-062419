require_relative '../config/environment'
require 'pry'
require 'json'
require 'tty-prompt'
require 'colorize'


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

   puts "
        +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+-+
        |B|A|M|C|H|E|L|L|A|R|O|O| |M|A|N|
        +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+-+".colorize(:blue).blink


   puts 'Welcome to Bamchellaroo Man!'
   @prompt.select("Is this your first festival?") do |menu|
       menu.choice 'new user', -> { create_user }
       menu.choice 'use existing', -> { select_existing_user }
       end
   end

   def select_existing_user
       choices = User.all.map {|user| user.name}
       current = @prompt.select("Oh yeah! I remember you, what was your name again?", choices)
       current_user = User.find_by(name: current)
       menu_choices(current_user)
   end

   def create_user
       user_login = @prompt.ask('What is your name?')
       @current_user = User.new(name: "#{user_login}")
       puts "Welcome to the party #{user_login}!"
       menu_choices(@current_user)
   end

   def menu_choices(current_user)
       @prompt.select("What would you like to do?") do |menu|
           menu.choice 'create new schedule', ->{ scheduler(current_user) }
           menu.choice 'view an existing schedule' 
           menu.choice 'update a schedule'
           menu.choice 'delete a schedule'
       end
   end

   def scheduler(current_user)
       set_time = 1
       show_choices = Show.all.where(time: 1)
       # @prompt.select("Who are you excited to see today?") do |menu|
       # end
       # binding.pry
   end


   def view_existing_schedule(current_user)
    puts "Here's your line-up:"
    Schedule.all.map do |sched|
      if sched.user == current_user
        puts "#{sched.artist} at #{sched.time}"
      end
    end
  end

  def update_schedule(current_user)
    puts "Having second thoughts on your current schedule?"
    view_existing_schedule(current_user)
    #want to see a different act in X timeslot?

  end

  def remove_schedule(current_user)
    Schedule.delete(schedule-instance-x)
    Schedule.create(new_act, x-time)
  end



end


cli = CommandLineInterface.new
cli.greet_user
