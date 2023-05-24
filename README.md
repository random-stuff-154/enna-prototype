# Contributers

This project was a collaborative effort to build a prototype for an addiction recovery app- enna. 

Big thank you to all those who contributed to this!

Georgia, Mike, Ben, Enyo. Thank you for all the work you put in developing this app, from user authentication, onboarding, chatbot integration, recovery tracker creation, and all the picky backend problems. And thanks to the rest of the team for helpful discussions and advice on all aspects of the app.




# ennaMVP-rubyrails

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
