RSpec.shared_context "frozen time" do
  let(:frozen_time) { Time.zone.parse("2024-06-15 10:00:00") }

  before { travel_to(frozen_time) }
  after { travel_back }
end
