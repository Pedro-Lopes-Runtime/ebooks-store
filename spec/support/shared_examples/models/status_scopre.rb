RSpec.shared_examples "filters by status scope" do |scope_name, expected_status|
  it "returns only #{scope_name} records" do
    # Create records with different statuses
    matching_record = create(described_class.name.underscore.to_sym, status: expected_status)
    other_statuses = described_class.statuses.keys - [ expected_status.to_s ]
    other_records = other_statuses.map { |status| create(described_class.name.underscore.to_sym, status: status) }

    results = described_class.send(scope_name)

    expect(results).to include(matching_record)
    other_records.each { |record| expect(results).to_not include(record) }
  end
end
