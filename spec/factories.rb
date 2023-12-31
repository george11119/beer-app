FactoryBot.define do
  sequence :username do |n|
    "john#{n}"
  end

  factory :user do
    username { generate :username }
    password { "Hunter2" }
    password_confirmation { "Hunter2" }
  end

  factory :brewery do
    name { "anonymous" }
    year { 2000 }
  end

  factory :beer do
    name { "anonymous" }
    style { "Lager" }
    brewery
  end

  factory :rating do
    score { 10 }
    beer
    user
  end
end