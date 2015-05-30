RSpec.shared_examples 'scheduled departures' do
  it "creates one for each stop_time" do
    expect(subject.departures.size).to eq(1)
  end

  it "is not realtime" do
    expect(subject.departures.first).to_not be_realtime
  end

  it "applies the departure time the scheduled stop_time" do
    expect(subject.departures.first.time).to eq(departure_time)
  end
end
