FactoryBot.define do
  factory :animal do
    name { "Bear" }
    kingdom
  end

  factory :kingdom do
    name { "Animal" }

    transient do
      with_animals { false }
      animal_count { 5 }
    end

    after(:create) do |kingdom, evaluator|
      if evaluator.with_animals
        create_list(:animal, evaluator.animal_count, kingdom: kingdom)
      end
    end
  end

  factory :human do
    name { "Non Active Record" }
  end
end
