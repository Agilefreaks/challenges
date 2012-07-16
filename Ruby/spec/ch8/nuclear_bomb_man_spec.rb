require "spec_helper"
require "nuclear_bomb_man"

describe NuclearBombMan do
  it { should be_a(NuclearBombMan) }

  describe "bfs" do
    it "should return true for a direct match" do
      subject.lines = [[0, 2, 4]]
      subject.bfs(0).should == true
      subject.matched_lines[0].should == 0
      subject.matched_columns[0].should == 0
    end
    it "should choose the next available column if the case might be" do
      subject.lines = [[0, 2, 4]]
      subject.matched_columns[0] = 0

      subject.bfs(0).should == true
      subject.matched_lines[0].should == 2
      subject.matched_columns[2].should == 0
    end
    it "should recurse to find an alternative" do
      subject.lines = [[0, 2, 4], [1, 3], [], [0]]
      subject.matched_columns[0] = 0
      subject.matched_columns[1] = 1
      subject.bfs(3).should == true
      subject.matched_lines[0].should == 2
      subject.matched_lines[3].should == 0
    end
  end

  describe "solve" do
    it "should solved the problem" do
      subject.lines = [[0, 2, 4], [1, 3], [], [0]]
      subject.solve.should == 3
    end
  end
end