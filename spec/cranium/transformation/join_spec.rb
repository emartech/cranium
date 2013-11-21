require_relative '../../spec_helper'

describe Cranium::Transformation::Join do

  let(:join) { Cranium::Transformation::Join.new }

  describe "#execute" do
    context "when validating its parameters" do
      before(:each) do
        join.source_left = "left source"
        join.source_right = "right source"
        join.target = "target source"
        join.match_fields = { field1: :field2 }
      end

      it "should raise an error if :source_left isn't set" do
        join.source_left = nil
        expect { join.execute }.to raise_error "Missing left source for join transformation"
      end

      it "should raise an error if :source_right isn't set" do
        join.source_right = nil
        expect { join.execute }.to raise_error "Missing right source for join transformation"
      end

      it "should raise an error if :target isn't set" do
        join.target = nil
        expect { join.execute }.to raise_error "Missing target for join transformation"
      end

      it "should raise an error if :match_fields is set but isn't a Hash" do
        join.match_fields = :field
        expect { join.execute }.to raise_error "Invalid match fields for join transformation"
      end
    end
  end

end
