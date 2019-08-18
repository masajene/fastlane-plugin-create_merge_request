# create_merge_request `fastlane` plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-create_merge_request)


## About create_merge_request

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. 

This will create a new merge request on GitLab.

## Getting Started

To get started with `fastlane-plugin-create_merge_request`, add it to your project by running:

```bash
fastlane add_plugin create_merge_request
```


## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins`.

```ruby
create_merge_request(
    api_token: "secret",
    project_id: "1000",                 # Gitlab Project ID
    title: "Amazing new feature",
    body: "Please pull this in!",       # optional
    source: "branch_name",              # optional Name of the branch where your changes are implemented (defaults to the current branch name)
    target: "develop",                  # optional Name of the branch you want your changes pulled into (defaults to `master`)
    assignee_id: "1773700",             # optional Assignee user ID
    labels: "bot",                      # optional Labels for MR as a comma-separated list
    milestone_id: "1",                  # optional The global ID of a milestone
    api_url: "http://yourdomain/api/v4" # optional, for GitLab self-host, defaults to "https://gitlab.com/api/v4"
  )
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
