FactoryGirl.define do
  factory :service do
    agency
    start_date Date.new(2000, 1, 1)
    end_date Date.new(3000, 12, 31)
  end
end
