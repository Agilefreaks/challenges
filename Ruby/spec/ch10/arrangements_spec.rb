require "spec_helper"
require "arrangements"

describe Arrangements do
  it { should be_a(Arrangements) }

  describe "#solve" do
    it "should solve for 2 teams" do
      matrix = Matrix[[0, 1, 1, 1],
                      [0, 0, 1, 1],
                      [0, 0, 0, 1],
                      [0, 0, 0, 0]]
      Arrangements.new(matrix).solve.should == "Yes 0 1 2 3"
    end
  end

  describe "add" do
    it "should add the node in front of the first" do
      matrix = Matrix[[0, 0],
                      [1, 0]]
      arrangements = Arrangements.new(matrix)
      arrangements.solution << 0
      arrangements.add(1)
      arrangements.solution.should == [1, 0]
    end
    it "should add it to the last" do
      matrix = Matrix[[0, 1],
                      [0, 0]]
      arrangements = Arrangements.new(matrix)
      arrangements.solution << 0
      arrangements.add(1)
      arrangements.solution.should == [0, 1]
    end
    it "should insert into place" do
      matrix = Matrix[[0, 1, 1],
                      [0, 0, 1],
                      [0, 0, 0]]
      arrangements = Arrangements.new(matrix)
      arrangements.solution.push(0).push(2)
      arrangements.add(1)
      arrangements.solution.should == [0, 1, 2]
    end
  end
end