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
        choices = User.all.map{|user| user.name}
        current = @prompt.select("Oh yeah! I remember you, what was your name again?", choices)
        current_user = User.find_by(name: current)
        menu_choices(current_user)
    end

    def create_user
        user_login = @prompt.ask('What is your name?')
        @current_user = User.create(name: "#{user_login}")
        puts "Welcome to the party #{user_login}!"
        menu_choices(@current_user)

    end

    def menu_choices(current_user)
        @prompt.select("What would you like to do?") do |menu|
            menu.choice 'create new schedule', -> { scheduler(current_user, set_time=1) }
            menu.choice 'view an existing schedule', -> { view_schedule(current_user) }
            menu.choice 'update a schedule', -> { remove_schedule(current_user) }
            menu.choice 'delete a schedule'
        end
    end

    def scheduler(current_user)
        if set_time == 11
            pick_headliner(current_user)
        else
            show_choices = Show.all.where(time: set_time)
            artist_names = show_choices.map{|show| show.artist}
            artist_choice = @prompt.select("Who are you excited to see today?", artist_names)
            chosen_show = Show.find_by(artist: artist_choice)
            Schedule.create(user_id: current_user.id, show_id: chosen_show.id)
            set_time+=1
            scheduler(current_user, set_time)
        end
    end

    def pick_headliner(current_user)
        main_choices = Show.all.where(time: 11)
        headliner_names = main_choices.map{|show| show.artist}
        headliner_choice = @prompt.select("Here's the main event! Who are you going to choose?", headliner_names)
        chosen_headliner = Show.find_by(artist: headliner_choice)
        Schedule.create(user_id: current_user.id, show_id: chosen_headliner.id)
        view_schedule(current_user)
    end

    def view_schedule(current_user)
        show_ids = current_user.schedules.map { |sched| sched.show_id }
        show_ids.each do |id|
          Show.all.map do |show|
            if show.id == id
              puts "#{show.artist} at #{show.time}"
              puts "------------------------------"
            end
          end
        end

    end


   def remove_schedule(current_user)
     show_choices = view_schedule(current_user)
     to_be_removed = @prompt.select("Having second thoughts? Please select a show you would like to ditch:", show_choices)
     Schedule.remove(to_be_removed.id)
   end






end


cli = CommandLineInterface.new
cli.greet_user
