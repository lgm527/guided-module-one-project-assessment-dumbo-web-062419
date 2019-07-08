require_relative '../config/environment'

class CommandLineInterface

  def initialize
    @prompt = TTY::Prompt.new
  end

end

cli = CommandLineInterface.new
