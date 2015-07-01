FactoryGirl.define do
  factory :admin do
    name { FFaker::Internet.user_name }
    nickname { FFaker::Internet.user_name }
    password { FFaker::Internet.password }
    email { FFaker::Internet.email }
  end
end