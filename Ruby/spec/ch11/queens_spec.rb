require "spec_helper"
require "queens"

describe Queens do
  it { should be_a(Queens) }

  describe "#initialize" do
    it "should init board" do
      subject.board.should == []
    end
  end

  describe "#add_line" do
    it "should map the bits" do
      subject.add_line("...")
      subject.board[0].should == "000".to_i(2)
    end
    it "should map the bits" do
      subject.add_line(".#.")
      subject.board[0].should == "010".to_i(2)
    end
  end

  describe "#calculate" do
    it "should return correct answer for 3x3 configuration with no obstacle" do
      subject.columns, subject.lines = 3, 3
      subject.add_line("...")
      subject.add_line("...")
      subject.add_line("...")
      subject.calculate.should == 17
    end
  end
end