module Response
  class ErrorMessageFactory
    def message_for_incorrect_project(lookup_match, available_projects)
      if lookup_match.empty?
        attachments = [available_projects_attachment(available_projects)]
        Message.new(text: Text::PROJECT_NOT_FOUND, attachments: attachments)
      else
        attachments = [matching_projects_attachment(lookup_match.elements)]
        Message.new(text: Text::MULTIPLE_PROJECTS_FOUND, attachments: attachments)
      end
    end

    def message_for_incorrect_task(lookup_match)
      if lookup_match.empty?
        Message.new(text: Text::TASK_NOT_FOUND)
      else
        Message.new(text: Text::MULTIPLE_TASKS_FOUND)
      end
    end

    private

    def available_projects_attachment(available_projects)
      available_projects_text = available_projects.map { |project| project_name(project) }.join("\n")
      Attachment.new(title: Text::AVAILABLE_PROJECTS, text: available_projects_text)
    end

    def matching_projects_attachment(matching_projects)
      matching_projects_text = matching_projects.map { |project| project_name(project) }.join("\n")
      Attachment.new(title: Text::MATCHING_PROJECTS, text: matching_projects_text)
    end

    def project_name(project)
      if project.code && !project.code.empty?
        "(#{project.code}) #{project.name}"
      else
        project.name
      end
    end
  end
end
