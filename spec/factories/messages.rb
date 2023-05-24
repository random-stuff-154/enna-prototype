FactoryBot.define do
  factory :message do
    content { "Message content" }
    chat
    user
    prompt_or_response { false }
    # set any other attributes that your model may have
    # date_time { Time.now }
  end
end
