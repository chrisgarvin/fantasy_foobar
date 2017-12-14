# Fantasy Foobar

A command line tool to track your fantasy football teams stats as they happen
throughout the game day. Will not guarantee a victory for you. In fact, I have
only seen my team lose each week as I tested this... be warned.

## Installation

    $ gem install fantasy_foobar

## Usage

```sh
fantasy_foobar
```

On first launch, you will need to add players to your team. (Loading player pool
takes some time, which I'll look to improve upon in a future update.)

If you've already added players to your team previously, re-launching will pull
in your previously created team, in which you could modify if necessary.

When you are finished setting your team, it will attempt to find any games from
the current week that have been played already, and print out any plays that
your players have made. For live games, it will print stats as they occur, so as
long as you leave the script running.

## Known areas to be improved in future updates (in no specific order)

* Include special teams statistics
* Detect kickers field goal length to properly count their fantasy point values
* Allow for configuration screen to set league settings (Currently set to .5
  PPR, otherwise standard)
* Display full teams fantasy output occasionally
* Allow for a cleaner way to quit rather than needing to use `Ctrl + C`
* (many more ideas in the pipeline, but feel free to suggest)

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/chrisgarvin/fantasy_foobar. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to adhere
to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Fantasy Foobar project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/chrisgarvin/fantasy_foobar/blob/master/CODE_OF_CONDUCT.md).
