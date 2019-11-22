FactoryBot.define do
  factory :user, aliases: [:owner] do
    sequence(:first_name) {|n| "Aaron#{n}"}
    sequence(:last_name) {|n| "Sumner#{n}"}
    sequence(:email){|n| "tester#{n}@example.com"}
    password "dottle-nouveau-pavilion-tights-furze"
  end
end
