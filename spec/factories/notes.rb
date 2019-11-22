FactoryBot.define do
  factory :note do
    message "my important note"
    association :project
    user {project.owner}
  end
end
