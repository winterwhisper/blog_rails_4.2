FactoryGirl.define do
  factory :comment do
    username { FFaker::Internet.user_name }
    email { FFaker::Internet.email }
    body 'foobar comment body'
  end
end