# DoppelDonger

DoppleDonger is a tool that helps you choose which champion to master next!
Take a look here! [http://doppeldonger.herokuapp.com/](http://doppeldonger.herokuapp.com/)

When we looked at Riots API Challenge (April-May 2016) and saw they wanted us to do something with the Mastery stats, we were lost. We wanted to make a tool that made you better, but masteries didn't necessarily mean you are good or bad at a champion. But it did mean you liked them... So we decided we would take this information to help you decide what champion to play next. We stored tons of mastery information, so that we could compare **your name** to summoners all across your region. We compare your information to theirs and using that information decide who you should play next.

####Challenges

This problem presented us with a number of Challenges.
1. There is no easy way to get aggregate data from the Riot API. We had to collect our own and store it in a database.
2. When looking at what database to use, we wanted to use PostgreSQL or MySQL. But the more research we did, we saw that Graph Databases were ideal for this situation. Neither of us had worked on a graph database before, so we were treading in new waters.
3. We wanted to display our data in a simple Web UI. However, both of our experience in Web was limited. At most we had spun up simple Sinatra servers that were never pretty. We had to learn how seriously work with CSS & Javascript for the first time.

####Tech Stack
Backend: Ruby
Database: Graph Story
Front End: Sinatra, HTML, CSS & Javascript (Used Twitter Bootstrap)
Platform: Heroku (PaaS)

####Getting Started

######Prereqs.
1. Ruby Installed
2. GraphStory Installed

######Getting the project up & running
1. Download the project from Github
2. Install Bundler ```gem install bundler```
3. Bundle the Gems ```bundle```
4. Set ENV Variables: GRAPHSTORY_URL to your Graphstory Database & RIOT_API_KEY to your API Key
5. Run Attribute Startup: ```ruby scripts/attribute_startup.rb```
6. Run Champion Startup: ```ruby scripts/champion_startup.rb```
7. Start your Sinatra server: ```ruby web.rb```
