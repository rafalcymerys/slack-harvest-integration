require_relative 'application'

map('/time') { run Controllers::TimeController }
