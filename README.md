# Contributers

This project was a collaborative effort to build a prototype for an addiction recovery app- enna. 

Big thank you to all those who contributed to this!

Georgia, Mike, Ben, Enyo. Thank you for all the work you put in developing this app, from user authentication, onboarding, chatbot integration, recovery tracker creation, and all the picky backend problems. And thanks to the rest of the team for helpful discussions and advice on all aspects of the app.




# ennaMVP-rubyrails

macbook setup 
```
mkdir my-apps
cd my-apps
git clone https://github.com/random-stuff-154/ennaMVP-rubyrails.git
sudo gem install rails
\curl -sSL https://get.rvm.io | bash -s stable
	(Close and reopen terminal)
rvm install ruby
rvm install 3.1.3
rvm use 3.1.3
cd my-apps/ennaMVP-rubyrails
brew install icu4c
brew install postgresql
brew info postgresql
	(to check it worked)
which pg_config
	(to check postgresql installation worked, if not try reinstalling after next step)
nano ~/.zshrc and add 
	export PATH="/usr/local/opt/postgresql/bin:$PATH"
bundle install
initdb /usr/local/var/postgres
pg_ctl -D /usr/local/var/postgres -l logfile start
mkdir /opt/homebrew/var/postgres/pg_log
nano /opt/homebrew/var/postgres/postgresql.conf
	(search for port and change to 5433)
brew services restart postgresql
rails db:create
rails db:migrate
rails s 

	(now to deploy the app)
brew tap heroku/brew && brew install heroku
heroku login
heroku git:remote -a enna-prototype


```

rails generating:
rails new \
  -d postgresql \
  -j webpack \
  -m https://raw.githubusercontent.com/lewagon/rails-templates/master/minimal.rb \
  rails-authentication

cd rails-authentication

devise setup:
Gemfile: gem "devise"
bundle install
rails generate devise:install

cloning repo:
go to 'code' green button, select ssh and copy the link. Then in terminal nagivate to where you want to clone the repo to, type:
```git clone <link>``` 
then enter.

Pull, branch, push:
```git pull origin main```
```gco -b <name of your branch, see trello> ```
```git add . ```
```gst ```(git status)
```git commit -m '<your descriptive message>' ```
```ggp ``` (git push from your branch)
# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

make sure the contents of your `package.json` are as follows:
```{
  "name": "enna-prototype",
  "version": "1.0.0",
  "description": "Prototype for enna with some functionality",
  "main": "index.js",
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "@emotion/react": "^11.10.6",
    "@emotion/styled": "^11.10.6",
    "@fontsource/roboto": "^4.5.8",
    "@hotwired/stimulus": "^3.2.1",
    "@hotwired/stimulus-webpack-helpers": "^1.0.1",
    "@hotwired/turbo-rails": "^7.3.0",
    "@material-ui/core": "^4.12.4",
    "@material-ui/icons": "^4.11.3",
    "@mui/icons-material": "^5.11.16",
    "@mui/material": "^5.11.16",
    "@mui/styled-engine-sc": "^5.11.11",
    "@mui/x-date-pickers": "^6.0.4",
    "@popperjs/core": "^2.11.6",
    "@rails/webpacker": "5.4.4",
    "babel-loader": "^8.0.6",
    "bootstrap": "^5.1.3",
    "dayjs": "^1.11.7",
    "react": "^18.0.3",
    "react-dom": "^18.0.3",
    "react_ujs": "^2.6.2",
    "styled-components": "^5.3.3",
    "webpack": "4.46.0",
    "webpack-cli": "^4.0.0",
    "webpack-node-externals": "^3.0.0"
  },
  "engines": {
    "node": "14.x"
  },
  "devDependencies": {
    "mini-css-extract-plugin": "^2.7.5",
    "webpack": "4.46.0",
    "webpack-dev-server": "^3"
  }
}
```

add all changes to a commit on the branch (in this case `main-deployment`) you want to deploy, then run:
``` git push heroku main-deployment:main ``` 

then database setup:

``` heroku run rake db:migrate --trace ```

# database debugging
Typical issues with postgres

```ActiveRecord::ConnectionNotEstablished: connection to server on socket "/tmp/.s.PGSQL.5432" failed: No such file or directory```

Check the PostgreSQL server's actual port. You can do this by running the following command in your terminal:
```ps aux | grep postgres```
Look for a line that contains postgres -D and note the port number after -p

Update your Rails application's configuration to use the correct port number. Open your config/database.yml file and make sure the port key for the relevant environment (development, production, etc.) is set to the port number you found in step 


You want to start a postgres server, by running this command :
```pg_ctl -D /usr/local/var/postgres start ```
but you're getting this error:

```pg_ctl: directory "/usr/local/var/postgres" does not exist```
you probably installed postgres with homebrew, therefore its in a different directory. So you run like this instead:
```
brew services start postgresql

Warning: Use postgresql@14 instead of deprecated postgresql
```

Other reasons you could be getting this error:
```ActiveRecord::ConnectionNotEstablished: connection to server on socket "/tmp/.s.PGSQL.5432" failed: No such file or directory
	Is the server running locally and accepting connections on that socket?
```
check that the `/opt/homebrew/var/postgresql@14/postgresql.conf` has the right port number. Then restart the postgres server:
`brew services restart postgresql@14`

now you'll need to create the database again (probably)" `rails db:create`

but most likely you can jump straight to `rails db:migrate`
