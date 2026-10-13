module Types
  class QueryType < Types::BaseObject
    field :events, [Types::EventType], null: false do
      argument :limit, Integer, required: false, default_value: 20
    end

    field :event, Types::EventType, null: true do
      argument :id, ID, required: true
    end

    def events(limit:)
      Event.order(:start_at).limit(limit.clamp(1, 50))
    end

    def event(id:)
      Event.find_by(id: id)
    end
  end
end
