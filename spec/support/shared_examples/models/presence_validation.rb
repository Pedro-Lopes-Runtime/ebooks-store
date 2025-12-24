RSpec.shared_examples "validates presence of" do |attribute|
  it "is invalid with no #{attribute}" do
    record = build_stubbed(described_class.name.underscore.to_sym, attribute => nil)
    expect(record).to_not be_valid
    expect(record.errors.full_messages).to include "#{attribute.to_s.humanize} can't be blank"
  end
end
