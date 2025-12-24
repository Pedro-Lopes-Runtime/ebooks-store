RSpec.shared_examples "validates enum" do |enum_name, expected_values|
  it "should have valid #{enum_name}" do
    expect(described_class.send(enum_name.to_s.pluralize).keys).to match_array expected_values
  end
end
