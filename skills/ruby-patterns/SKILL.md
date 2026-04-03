---
name: ruby-patterns
description: "Ruby 3+ idioms, Rails patterns, and testing with RSpec. Load for Ruby code."
---

# Ruby Patterns Skill

## Key Idioms

### Pattern Matching (Ruby 3+)
```ruby
case response
in { status: 200, body: { users: [User => first, *] } }
  puts "First user: #{first.name}"
in { status: 404 }
  raise NotFoundError
in { status: (500..) }
  raise ServerError
end
```

### Data Class (Ruby 3.2+)
```ruby
User = Data.define(:id, :name, :email) do
  def display_name = "#{name} <#{email}>"
end
user = User.new(id: "1", name: "Alice", email: "a@t.com")
```

### Blocks & Procs
```ruby
def with_retry(max: 3, &block)
  attempts = 0
  begin
    attempts += 1
    block.call
  rescue StandardError => e
    retry if attempts < max
    raise
  end
end

with_retry(max: 5) { api.fetch_data }
```

### Enumerable
```ruby
active_emails = users.select(&:active?).map(&:email)
users_by_role = users.group_by(&:role)
total = orders.filter_map { |o| o.total if o.completed? }.sum
```

## Rails Patterns

### Concerns
```ruby
module Trackable
  extend ActiveSupport::Concern
  included do
    has_many :activities, as: :trackable
    after_create :log_creation
  end
  def log_creation
    activities.create!(action: "created", user: Current.user)
  end
end
```

### Service Objects
```ruby
class Users::Create
  def initialize(params:, current_user:)
    @params = params
    @current_user = current_user
  end

  def call
    user = User.new(@params)
    ActiveRecord::Base.transaction do
      user.save!
      UserMailer.welcome(user).deliver_later
    end
    user
  end
end
```

## Testing (RSpec)
```ruby
RSpec.describe UserService do
  describe "#create" do
    let(:repo) { instance_double(UserRepository) }
    let(:service) { described_class.new(repo:) }

    it "creates user with valid data" do
      allow(repo).to receive(:save).and_return(build(:user, name: "Alice"))
      result = service.create(name: "Alice", email: "a@t.com")
      expect(result.name).to eq("Alice")
      expect(repo).to have_received(:save).once
    end

    it "raises on duplicate email" do
      allow(repo).to receive(:find_by_email).and_return(build(:user))
      expect { service.create(name: "Bob", email: "dup@t.com") }
        .to raise_error(DuplicateEmailError)
    end
  end
end
```
