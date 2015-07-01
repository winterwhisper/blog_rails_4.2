FactoryGirl.define do
  factory :tag do
    transient do
      with_post false
    end

    value 'foobar tag'

    after(:build) do |tag, evaluator|
      tag.posts << create(:post) if evaluator.with_post
    end
  end

  factory :tag_value_with_whitespace, class: Tag do
    value ' foobar tag '
  end
end