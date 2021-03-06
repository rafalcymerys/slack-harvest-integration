require 'sinatra'
require 'harvested'
require 'slack'
require 'sidekiq'
require 'rest-client'

require_relative 'app/configuration'

require_relative 'app/controllers/slack'

require_relative 'app/jobs/start_new_entry'

require_relative 'app/security/slack_request_validator'
require_relative 'app/security/errors'

require_relative 'app/serializer/message'

require_relative 'app/service/harvest_time'
require_relative 'app/service/harvest_user'
require_relative 'app/service/slack'

require_relative 'lib/command/start_new_entry'

require_relative 'lib/task/start_new_entry'
require_relative 'lib/task/finish_current_entry'
require_relative 'lib/task/switch_entry'

require_relative 'lib/lookup/errors'
require_relative 'lib/lookup/project'
require_relative 'lib/lookup/task'
require_relative 'lib/lookup/field_based_filter'
require_relative 'lib/lookup/match'

require_relative 'lib/matcher/slack_harvest_user'

require_relative 'lib/parser/errors'
require_relative 'lib/parser/hours'
require_relative 'lib/parser/entry_command'
require_relative 'lib/parser/entry_command_result'

require_relative 'lib/response/attachment'
require_relative 'lib/response/message'
require_relative 'lib/response/error_message_factory'
require_relative 'lib/response/text'
