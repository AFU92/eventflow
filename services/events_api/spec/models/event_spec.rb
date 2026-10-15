require "rails_helper"

RSpec.describe Event, type: :model do
  it "accepts a published event with a date" do
    event = described_class.new(title: "Summit", status: "published", start_at: 1.day.from_now)
    expect(event).to be_valid
  end

  it "rejects an unknown status" do
    event = described_class.new(title: "Summit", status: "closed", start_at: 1.day.from_now)
    expect(event).not_to be_valid
    expect(event.errors[:status]).to be_present
  end

  it "requires a title and a start date" do
    event = described_class.new(status: "draft")
    expect(event).not_to be_valid
    expect(event.errors[:title]).to be_present
    expect(event.errors[:start_at]).to be_present
  end
end
