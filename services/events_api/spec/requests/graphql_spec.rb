require "rails_helper"

RSpec.describe "Events GraphQL", type: :request do
  let!(:event) do
    Event.create!(
      title: "Summit",
      status: "published",
      start_at: 1.day.from_now
    )
  end

  it "returns the requested event and public date field" do
    post "/graphql",
         params: {
           query: "query($id: ID!) { event(id: $id) { id title startsAt } }",
           variables: { id: event.id.to_s }
         }.to_json,
         headers: { "CONTENT_TYPE" => "application/json" }

    expect(response).to have_http_status(:ok)
    
    data = response.parsed_body.dig("data", "event")
    expect(data.fetch("id")).to eq(event.id.to_s)
    expect(data.fetch("startsAt")).to be_present
  end

  it "returns null for a missing ID" do
    post "/graphql",
         params: {
           query: '{ event(id: "999999") { id } }'
         }.to_json,
         headers: { "CONTENT_TYPE" => "application/json" }

    expect(response.parsed_body.dig("data", "event")).to be_nil
  end
end
