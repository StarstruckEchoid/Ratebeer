FactoryBot.define do
  factory :user do
    username { "Pekka" }
    password { "Foobar1" }
    password_confirmation { "Foobar1" }
  end

  factory :brewery do
    name { "anonymous" }
    year { 1900 }
    active { true }
  end

  factory :beer do
    name { "anonymous" }
    style { FactoryBot.create(:style) }
    brewery # olueeseen liittyvä panimo luodaan brewery-tehtaalla
  end

  factory :rating do
    beer # reittaukseen liittyvä olut luodaan beer-tehtaalla
  end

  factory :style do
    name { "Lager" }
    description { "A tasty kind of beer!" }
  end
end
