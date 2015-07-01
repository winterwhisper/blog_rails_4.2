FactoryGirl.define do
  factory :post do
    transient do
      with_comment false
    end

    title 'foobar post title'
    body 'foobar post body'
    comments_count 0

    factory :post_with_valid_pending_tags do
      pending_tags 'foobar tag'
    end

    factory :post_with_null_value_pending_tags do
      pending_tags '   '
    end

    after(:build) do |post, evaluator|
      post.comments.new(FactoryGirl.attributes_for(:comment)) if evaluator.with_comment
    end
  end
end