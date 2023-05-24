namespace :habit_tracker do
  desc "Create new instances of the habit tracker every day for each user with the date as yesterday"
  task :daily_job => :environment do
    # Get all users
    users = User.all

    # Loop through each user
    users.each do |user|
      # Create a new instance of the model with user_id and yesterday's date
      HabitTracker.create(user_id: user.id, date: Date.yesterday)
    end
  end
end
