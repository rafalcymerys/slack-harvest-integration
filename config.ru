require_relative 'application'

map('/slack') { run Controllers::Slack }
