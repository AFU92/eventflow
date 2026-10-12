class Event < ApplicationRecord
  validates :title, :start_at, presence: true
  validates :status, inclusion: { in: %w[draft published] }
end
