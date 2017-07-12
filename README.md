# Lunch Buddy
A Slack bot, that posts chat messages containing the daily menus of specific restaurants every day.

## Requirements
This application uses [slack-ruby-client](https://github.com/slack-ruby/slack-ruby-client) to integrate the slack bot. Follow their instructions on how to set it up.

You need to set the environment variable `SLACK_API_TOKEN`.

## Installation
This application uses [whenever](https://github.com/javan/whenever) for the cron job setup. To set up the cron jobs run:

`whenever --update-crontab`

Make sure that cron has access to the required environment variable `SLACK_API_TOKEN`.

## Contributing
If you want to add a new restaurant you only need to:

1. Create the model:

`app/models/restaurant/new_restaurant.rb`

2. Let it inherit from `BaseRestaurant`
```ruby
module Restaurant
  class NewRestaurant < BaseRestaurant
    def get_contents(date); end
  end
end
```

3. Implement the `get_contents(date)` method. It should return an array of strings containing the menus of the day.
```ruby
def get_contents(date)
  date.friday? ? ['Fisch'] : ['Schnitzel', 'Moules et frites']
end
```

See `app/models/restaurant/lilly_jo.rb` for a working example.

In general any contribution is appreciated. To do so just:

1. Fork the repository
2. Create a branch (`git checkout -b new-branch`)
3. Commit your changes (`git commit -am 'Add great new thing'`)
4. Push to the branch (`git push origin new-branch`)
5. Create new Pull Request
