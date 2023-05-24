require 'sendgrid-ruby'
include SendGrid

from = Email.new(email: 'team@enna-mind.com') # Replace with your sender email
to = Email.new(email: 'jordan.esmith@icloud.com') # Replace with the recipient's email
subject = 'Sending with SendGrid is Fun'
content = Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
mail = Mail.new(from, subject, to, content)

api_key = ENV['SENDGRID_API_KEY'] # Replace with your SendGrid API key
sg = SendGrid::API.new(api_key: api_key)
response = sg.client.mail._('send').post(request_body: mail.to_json)
puts response.status_code
puts response.body
puts response.headers
