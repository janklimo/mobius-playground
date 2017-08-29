FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "person#{n}@example.com"}
    password '1234test'
  end

  factory :admin, parent: :user do
    is_admin true
  end

  factory :transaction do
    association :sender, factory: :user
    association :recipient, factory: :user
    num_credits 10
  end
end
