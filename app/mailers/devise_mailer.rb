class DeviseMailer < Devise::Mailer
  helper :application
  layout 'mailer'

  def default_url_options
    { host: Rails.application.config.action_mailer.default_url_options[:host] }
  end

  def headers_for(action, opts)
    super.merge!({ from: custom_from_email_address(opts) })
  end

  private

  def custom_from_email_address(opts)
    opts[:from] || 'team@enna-mind.com'
  end
end
