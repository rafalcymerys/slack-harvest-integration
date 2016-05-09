module Response
  class ErrorMessageFactory
    def message_for_incorrect_project(lookup_match, available_projects)
      if lookup_match.empty?
        text = Text::PROJECT_NOT_FOUND
        attachments = [available_projects_attachment(available_projects)]
      else
        text = Text::MULTIPLE_PROJECTS_FOUND
        attachments = [matching_projects_attachment(lookup_match.elements)]
      end
      Message.new(text: text, attachments: attachments)
    end

    def message_for_incorrect_task(lookup_match, available_tasks)
      if lookup_match.empty?
        attachments = [available_tasks_attachment(available_tasks)]
        Message.new(text: Text::TASK_NOT_FOUND, attachments: attachments)
      else
        attachments = [matching_tasks_attachment(lookup_match.elements)]
        Message.new(text: Text::MULTIPLE_TASKS_FOUND, attachments: attachments)
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

    def available_tasks_attachment(available_tasks)
      available_tasks_text = available_tasks.map(&:name).join("\n")
      Attachment.new(title: Text::AVAILABLE_TASKS, text: available_tasks_text)
    end

    def matching_tasks_attachment(matching_tasks)
      matching_tasks_text = matching_tasks.map(&:name).join("\n")
      Attachment.new(title: Text::MATCHING_TASKS, text: matching_tasks_text)
    end
  end
end
