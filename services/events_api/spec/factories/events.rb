FactoryBot.define do
  factory :event do
    title { "Conference" }
    start_at { 1.day.from_now }
    status { "draft" }
  end
end