RSpec.shared_examples "a publishable resource" do
  describe "status transitions" do
    context "when draft" do
      before { subject.status = :draft }

      it "can be submitted for review" do
        subject.submit_for_review!
        expect(subject.status).to eq("pending")
      end
    end

    context "when pending" do
      before { subject.status = :pending }

      it "can be published" do
        subject.publish!
        expect(subject.status).to eq("live")
      end
    end
  end
end
