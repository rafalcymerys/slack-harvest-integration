# Slack - Harvest Integration

Let your team manage their harvest entries via slack.

## Configuration

Configuration is passed through env variables.

You'll need the following:
```
SLACK_TOKEN - token configured for slash command
SLACK_DOMAIN - domain of your team
SLACK_API_TOKEN - token for accessing slack API

HARVEST_SUBDOMAIN - domain of your harvest account
HARVEST_USERNAME, HARVEST_PASSWORD - credentials for an admin user in your harvest account
```

Also, you need to provide a working redis instance for sidekiq to work.

## Configuring slack

Create a new slash command for your team, with endpoint pointing to `https://slack-harvest-integration-host/slack`
Also get a API token through account admin panel.

## Deployment

The integration is a simple rack-based app.
The simplest way to run it is to use `bundle exec rackup`

Also, you'll need to launch sidekiq workers.
`bundle exec sidekiq -r ./worker.rb`

### Deploying to heroku

Provided Procfile should be fine.

Configure the environment via `heroku config:set VARIABLE=VALUE`

You can use Redis To Go as redis provider.
For a free plan, you'll need to pass the following in your environment.

```
REDIS_PROVIDER=REDISTOGO_URL
SIDEKIQ_CONCURRENCY=2
```

## Usage

Users can post commands anywhere, they won't be visible to other users.

The integration uses email address to match slack and harvest accounts. 
If they don't match, user won't be able to use harvest commands in slack.

### Switching active time entry

`/[slash_command] [project] [task] [note (multiple words)]`

eg.

`/entry Website Management Getting the team ready`

You can also use first letters for project or task name, as long as it points to single name

`/entry Web Manag Getting the team ready`

If you started working on a task a while ago, but forgot to switch your timer, you can add duration at the end

`/entry Web Manag Getting the team ready 1:30`

This will subtract 1:30 from your current entry and start a new one (Website -> Management) with 1:30 already on timer.

## Contributing

Pull requests are welcome. :)
