# ScrumBoard

A simple Kanban style board for keeping track of tasks.

Currently resides at https://peaceful-reaches-8323.herokuapp.com/

### Host Yourself
#### Dependencies
Currently configured to run on postgresql because that's what Heroku requires. I developed using sqlite though.
Developed on rails 4.1.6 and ruby 2.2.0. I make no promises for how it will behave on other versions.
##### Steps
1. Clone repo
2. ``` bundle install ```
3. ``` rake db:migrate ```
4. It's a Rails app, so launch with `rails server`

To run the test simply do `rake spec`
The current server is just the default (webrick). Feel free to use whatever you like (thin, unicorn, ... etc).

### Contributing
To be honest, I have given it much thought. I made this mostly as an exercise to learn Rails, css, and some basic Javascript stuff. If you feel something is wrong or could be improved, open an issue. Or just fork it, make the change yourself, and submit a pull request.
