# Lunch Buddy
A Slack bot, that posts chat messages containing the daily menus of specific restaurants every day.

## Requirements
This application uses [slack-ruby-client](https://github.com/slack-ruby/slack-ruby-client) to integrate the slack bot. Follow their instructions on how to set it up.

## Installation
This application uses [whenever](https://github.com/javan/whenever) for the cron job setup. To set up the cron jobs run:

`whenever --update-crontab`

## Contributing
1. Fork the repository
2. Create a branch (git checkout -b new-branch)
3. Commit your changes (git commit -am 'Add great new thing')
4. Push to the branch (git push origin new-branch)
5. Create new Pull Request
