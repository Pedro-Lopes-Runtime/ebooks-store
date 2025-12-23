RSpec.shared_examples "validates uniqueness of" do |attribute|
  it "is invalid if #{attribute} is already being used" do
    existing_record = create(described_class.name.underscore.to_sym)
    new_record = build(described_class.name.underscore.to_sym, attribute => existing_record.send(attribute))

    expect(new_record).to_not be_valid
    expect(new_record.errors.full_messages).to include "#{attribute.to_s.humanize} has already been taken"
  end
end
