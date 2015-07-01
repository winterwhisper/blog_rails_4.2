if Rails.env.test?
  Rails.application.routes.default_url_options[:host]= 'test.host'
end