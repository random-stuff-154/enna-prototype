FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    # add any other attributes you need for your tests
    # for example, if you have a field named `anonymous_id`, you might set it as follows
    # anonymous_id { 1 }
  end
end
