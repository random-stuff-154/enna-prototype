# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "creating 2 fake users..."

user1 = User.create(
  email: 'testing@gmail.com',
  password: 'testing',
  anonymous_id: '123456789',
  question_1_answer: 'a lot',
  question_2_answer: 'a bit',
  question_3_answer: 'not much'
)

puts "..."

user2 = User.create(
  email: 'testing2@gmail.com',
  password: 'testing',
  anonymous_id: '123456789',
  question_1_answer: 'prefer not to say',
  question_2_answer: 'not much',
  question_3_answer: 'prefer not to say'
)

puts "2 fake users created!"

puts "creating 4 fake abstinence goals..."

abstinencegoal1 = AbstinenceGoal.create(
  user_id: 1,
  current_goal: false,
  start_date: DateTime.new(2023, 4, 1, 0, 0, 0),
  length: 5,
  achieved: nil
)

puts "..."

abstinencegoal2 = AbstinenceGoal.create(
  user_id: 2,
  current_goal: false,
  start_date: DateTime.new(2023, 4, 2, 0, 0, 0),
  length: 5,
  achieved: nil
)

puts "..."

abstinencegoal3 = AbstinenceGoal.create(
  user_id: 1,
  current_goal: true,
  start_date: DateTime.new(2023, 4, 18, 0, 0, 0),
  length: 7,
  achieved: nil
)

puts "..."

abstinencegoal4 = AbstinenceGoal.create(
  user_id: 2,
  current_goal: false,
  start_date: DateTime.new(2023, 4, 19, 0, 0, 0),
  length: 7,
  achieved: nil
)

puts "4 fake abstinence goals created!"

puts "creating 6 fake abstinence tracker trackings..."

abstinencetrackertracking1 = AbstinenceTracker.create(
  user_id: 1,
  date: DateTime.new(2023, 4, 18, 0, 0, 0),
  abstained: true
)

puts "..."

abstinencetrackertracking2 = AbstinenceTracker.create(
  user_id: 2,
  date: DateTime.new(2023, 4, 18, 0, 0, 0),
  abstained: nil
)

puts "..."

abstinencetrackertracking3 = AbstinenceTracker.create(
  user_id: 1,
  date: DateTime.new(2023, 4, 19, 0, 0, 0),
  abstained: nil
)

puts "..."

abstinencetrackertracking4 = AbstinenceTracker.create(
  user_id: 2,
  date: DateTime.new(2023, 4, 19, 0, 0, 0),
  abstained: false
)

puts "..."

abstinencetrackertracking5 = AbstinenceTracker.create(
  user_id: 1,
  date: DateTime.new(2023, 4, 20, 0, 0, 0),
  abstained: false
)

puts "..."

abstinencetrackertracking6 = AbstinenceTracker.create(
  user_id: 2,
  date: DateTime.new(2023, 4, 20, 0, 0, 0),
  abstained: true
)

puts "6 fake abstinence tracker trackings created!"
