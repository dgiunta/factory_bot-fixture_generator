FactoryBot.define do
  factory :animal do
    name {"Bear"}
  end

  factory :human do
    name { "Non Active Record" }
  end
end
