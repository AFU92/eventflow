module Types
  class EventType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :status, String, null: false
    field :starts_at, GraphQL::Types::ISO8601DateTime,
          null: false, method: :start_at
  end
end
