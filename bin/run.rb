require_relative '../config/environment'
require 'pry'
require 'json'
require 'tty-prompt'
require 'colorize'
require 'rmagick'
require 'catpix'


#Greeting

#prompt: create user or use existing

#new user: enters name User.new -> create schedule

#Existing user: new schedule, view schedule, edit schedule, or delete schedule

#New schedule gives a prompt to pick between artists playing at a certain time. Once you pick your artists for each conflicting time frame it creates a new schedule

class CommandLineInterface

  def initialize
    @prompt = TTY::Prompt.new
  end

  def print_image
    Catpix::print_image "bin/Umphreys.jpg",
    :limit_x => 1.0,
    :limit_y => 0,
    :center_x => true,
    :center_y => true,
    :bg => "white",
    :bg_fill => true,
    :resolution => "high"
  end

#   def play_dead
#     afplay 'bin/Grateful Dead - The Music Never Stopped.mp3'
#   end

  def greet_user
    pid = fork{ exec 'afplay', 'bin/GratefulDead-TheMusicNeverStopped.mp3' }
    print_image


    puts "
         +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+-+
         |B|A|M|C|H|E|L|L|A|R|O|O| |M|A|N|
         +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+-+".colorize(:blue).blink


    puts '
          Welcome to Bamchellaroo Man!'
    @prompt.select("Is this your first festival?") do |menu|
        menu.choice 'yup, let me create a new user', -> { create_user }
        menu.choice 'hell no, use my existing account', -> { select_existing_user }
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
            menu.choice 'create new schedule', ->{ scheduler(current_user, set_time=1) }
            menu.choice 'view an existing schedule', -> { view_schedule(current_user) }
            menu.choice 'update a schedule', -> { update_schedule(current_user) }
            menu.choice 'delete a schedule', -> { remove_schedule(current_user) }
        end
    end

    def scheduler(current_user, set_time)
        if set_time == 11
            pick_headliner(current_user)
        else
            show_choices = Show.all.where(time: set_time)
            artist_names = show_choices.map{|show| show.artist}
            artist_choice = @prompt.select("Who are you excited to see today?", artist_names, 'skip')
                if artist_choice == 'skip'
                    skip(current_user, set_time)
                end
            chosen_show = Show.find_by(artist: artist_choice)
            Schedule.create(user_id: current_user.id, show_id: chosen_show.id)
            set_time+=1
            scheduler(current_user, set_time)
        end
    end

    def skip(current_user, set_time)
        set_time+=1
        scheduler(current_user, set_time)
    end


    def pick_headliner(current_user)
        main_choices = Show.all.where(time: 11)
        headliner_names = main_choices.map{|show| show.artist}
        headliner_choice = @prompt.select("Here's the main event! Who are you going to choose?", headliner_names)
        chosen_headliner = Show.find_by(artist: headliner_choice)
        Schedule.create(user_id: current_user.id, show_id: chosen_headliner.id)
        view_schedule(current_user)
    end

    def get_user_show_ids(current_user)
      current_user.schedules.map { |sched| sched.show_id }
    end

    def view_schedule(current_user)
        puts "
               Here's what you got so far:"
        puts "------------------------------------------------------------"
        get_user_show_ids(current_user).each do |id|
          Show.all.map do |show|
            if show.id == id
              puts "#{show.artist} at #{show.time}"
              puts "------------------------------------------------------------"
            end
          end
        end
        @prompt.select('How is it lookin?') do |menu|
            menu.choice "Actually, let me go back...".colorize(:blue), -> { menu_choices(current_user) }
            menu.choice "Rock on!".colorize(:magenta), -> { print_image }
        end
        pid = fork{ exec 'killall', 'afplay' }
    end


   def remove_schedule(current_user)
     show_ids = get_user_show_ids(current_user)
     show_choices = []
     show_ids.each do |id|
       Show.all.map do |show|
         if show.id == id
           show_choices << show.artist
         end
       end
     end
     to_be_removed = @prompt.select("Please select a show you would like to ditch:", show_choices, "Eh, nevermind")
      if to_be_removed == "Eh, nevermind"
        view_schedule(current_user)
      else
        show_to_remove = Show.find_by(artist: to_be_removed)
        Schedule.where(user_id: current_user, show_id: show_to_remove.id).destroy_all
        puts "Alright, goodbye #{to_be_removed}"
        view_schedule(current_user)
      end
   end

   def destroy_all_schedules
      Schedule.destroy_all
   end

   def update_schedule(current_user)
     show_ids = get_user_show_ids(current_user)
     show_choices = []
     show_ids.each do |id|
       Show.all.map do |show|
         if show.id == id
           show_choices << show.artist
         end
       end
     end
     to_be_edited = @prompt.select("Having second thoughts? Please select what you would like to change:", show_choices, "Eh, nevermind")
     if to_be_edited == "Eh, nevermind"
       view_schedule(current_user)
     else
       show_to_remove = Show.find_by(artist: to_be_edited)
       set_time = show_to_remove.time
       Schedule.where(user_id: current_user, show_id: show_to_remove.id).destroy_all
       puts "Alright, that show is gone. Now time to find another show to replace it!"
       show_choices = Show.all.where(time: set_time)
       artist_names = show_choices.map{|show| show.artist}
       artist_choice = @prompt.select("Who are you excited to see today?", artist_names)
       chosen_show = Show.find_by(artist: artist_choice)
       Schedule.create(user_id: current_user.id, show_id: chosen_show.id)
       puts "Rock on!"
       print_image
     end
   end



end


cli = CommandLineInterface.new
cli.greet_user
