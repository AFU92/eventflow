Event.find_or_initialize_by(id: 1).tap do |event|
  event.update!(
    title: "Tech Summit",
    status: "published",
    start_at: 7.days.from_now
  )
end

ActiveRecord::Base.connection.reset_pk_sequence!("events")
