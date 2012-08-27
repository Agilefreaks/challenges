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
      subject.number_of_columns, subject.number_of_lines = 3, 3
      subject.add_line("...")
      subject.add_line("...")
      subject.add_line("...")
      subject.calculate.should == 17
    end
  end

  describe "move_next" do
    before { subject.number_of_lines, subject.number_of_columns = 3, 3 }
    it "should move to the next column" do
      subject.move_next(1, 1).should == [1, 2]
    end
    it "should move to the next line" do
      subject.move_next(1, 2).should == [2, 0]
    end
    it "should return nil when there is no place to go" do
      subject.move_next(2, 2).should == [nil, nil]
    end
  end
end