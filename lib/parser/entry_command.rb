module Parser
  class EntryCommand
    def initialize
      @hours_parser = Hours.new
    end

    def parse(command_string)
      words = command_string.split(' ')
      raise IncorrectCommandError if words.size < 2

      project, task, *remaining = words
      hours = nil

      if hours_parser.valid?(remaining.last)
        hours = hours_parser.parse(remaining.pop)
      end

      notes = remaining.join(' ')

      EntryCommandResult.new(project: project, task: task, notes: notes, hours: hours)
    end

    private

    attr_reader :hours_parser
  end
end
