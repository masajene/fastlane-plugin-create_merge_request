require 'fastlane/action'

module Fastlane
  module Actions
    module SharedValues
      CREATE_MARGE_REQUEST_HTML_URL = :CREATE_MARGE_REQUEST_HTML_URL
    end

    class CreateMergeRequestAction < Action
      def self.run(params)
        require 'excon'

        target_project_id = params[:target_project_id] || params[:project_id]

        UI.message("Creating new merge request from #{params[:source]} to branch #{params[:target]} of project_id #{target_project_id}")

        url = "#{params[:api_url]}/projects/#{params[:project_id]}/merge_requests"

        headers = {
          'Content-Type' => 'application/json',
          'Private-Token' => "#{params[:api_token]}"
        }

        payload = {
          'title' => params[:title],
          'source_branch' => params[:source],
          'target_branch' => params[:target],
          'assignee_id' => params[:assignee_id],
          'labels' => params[:labels],
          'target_project_id' => target_project_id,
        }
        payload['description'] = params[:body] if params[:body]

        response = Excon.post(url, headers: headers, body: payload.to_json)

        if response[:status] == 201
          body = JSON.parse(response.body)
          id = body['iid']
          web_url = body['web_url']
          Actions.lane_context[SharedValues::CREATE_MARGE_REQUEST_HTML_URL] = web_url

          UI.success("Successfully created pull request ##{id}. You can see it at '#{web_url}'")
          return web_url
        elsif response[:status] != 200
          body = JSON.parse(response.body)
          UI.error("GitLab responded with #{response[:status]}: #{body['message']}")
          return nil
        end
      end

      def self.description
        "This will create a new marge request on GitLab"
      end

      def self.authors
        ["masashi mizuno"]
      end

      def self.return_value
        "The marge request URL when successful"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :api_token,
                                       env_name: "GITLAB_MERGE_REQUEST_API_TOKEN",
                                       description: "Personal API Access Token for GitLab",
                                       sensitive: true,
                                       default_value: ENV["GITLAB_API_TOKEN"],
                                       is_string: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :project_id,
                                       env_name: "GITLAB_MERGE_REQUEST_PROJECT_ID",
                                       description: "The id of the project",
                                       is_string: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :target_project_id,
                                       env_name: "GITLAB_MERGE_REQUEST_PROJECT_TARGET_PROJECT_ID",
                                       description: "The id of the project you want to submit the merge request to",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :title,
                                       env_name: "GITLAB_MERGE_REQUEST_TITLE",
                                       description: "The title of the merge request",
                                       is_string: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :body,
                                       env_name: "GITLAB_MERGE_REQUEST_BODY",
                                       description: "The contents of the pull request",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :source,
                                       env_name: "GITLAB_MERGE_REQUEST_SOURCE_BRANCH",
                                       description: "The name of the branch where your changes are implemented (defaults to the current branch name)",
                                       is_string: true,
                                       default_value: Actions.git_branch,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :target,
                                       env_name: "GITLAB_MERGE_REQUEST_TARGET_BRANCH",
                                       description: "The name of the branch you want your changes pulled into (defaults to `master`)",
                                       is_string: true,
                                       default_value: 'master',
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :assignee_id,
                                        env_name: "GITLAB_MERGE_REQUEST_ASSIGNEE_ID",
                                        description: "Assignee user ID",
                                        is_string: false,
                                        default_value: '0',
                                        optional: true),
          FastlaneCore::ConfigItem.new(key: :labels,
                                        env_name: "GITLAB_MERGE_REQUEST_LABELS",
                                        description: "Labels for MR as a comma-separated list",
                                        is_string: false,
                                        default_value: '',
                                        optional: true),
          FastlaneCore::ConfigItem.new(key: :api_url,
                                       env_name: "GITLAB_MERGE_REQUEST_API_URL",
                                       description: "The URL of GitLab API",
                                       is_string: true,
                                       default_value: 'https://gitlab.com/api/v4',
                                       optional: true)
        ]
      end

      def self.output
        [
          ['CREATE_MARGE_REQUEST_HTML_URL', 'Web url of the merge request that we created.']
        ]
      end

      def self.is_supported?(platform)
        return true
      end

       def self.example_code
        [
          'create_merge_request(
            api_token: ENV["GITLAB_TOKEN"],
            project_id: "100",
            target_project_id: "90"
            title: "Amazing new feature",
            source: "my-feature",                 # optional, defaults to current branch name
            target: "master",                     # optional, defaults to "master"
            body: "Please pull this in!",         # optional
            api_url: "http://yourdomain/api/v3"   # optional
          )'
        ]
      end

      def self.category
        :source_control
      end
    end
  end
end