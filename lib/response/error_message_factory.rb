module Response
  class ErrorMessageFactory
    def message_for_incorrect_project(lookup_match)
      if lookup_match.empty?
        Message.new(text: Text::PROJECT_NOT_FOUND)
      else
        Message.new(text: Text::MULTIPLE_PROJECTS_FOUND)
      end
    end

    def message_for_incorrect_task(lookup_match)
      if lookup_match.empty?
        Message.new(text: Text::TASK_NOT_FOUND)
      else
        Message.new(text: Text::MULTIPLE_TASKS_FOUND)
      end
    end
  end
end
