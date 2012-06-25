class AVLTree
  attr_accessor :root

  def initialize(array = [])
    #create root
    @root = nil
    array.each do |n|
      insert n
    end
  end

  def insert(v)
    i_node = create_node(v)
    result = 0

    prev_node = nil
    curr_node = @root
    until curr_node.nil?
      prev_node = curr_node
      if i_node.value < curr_node.value
        result += curr_node.occurrences

        # add right child occurrences
        result += curr_node.right.children_count + curr_node.right.occurrences unless curr_node.right.nil?

        curr_node = curr_node.left
      elsif i_node.value > curr_node.value
        curr_node = curr_node.right
      else
        # add right child occurrences
        result += curr_node.right.children_count + curr_node.right.occurrences unless curr_node.right.nil?

        break
      end
    end

    if prev_node.nil?
      @root = i_node
    else
      i_node.parent = prev_node
      if i_node.value < prev_node.value
        prev_node.left = i_node
      elsif i_node.value > prev_node.value
        prev_node.right = i_node
      else
        prev_node.occurrences += 1
      end
    end

    i_node.update_height
    i_node.update_children_count
    @root = i_node.balance

    result
  end

  private

  def create_node(v = nil)
    AVLNode.new(:value => v)
  end
end

class AVLNode
  BAL_H = 1
  attr_accessor :height, :left, :right, :value, :parent, :occurrences, :children_count

  def initialize args
    @height = 0
    @left = nil
    @right = nil
    @value = nil
    @parent = nil
    @occurrences = 1
    @children_count = 0
    args.each do |k, v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def balance
    rotate if difference.abs > BAL_H
    return self if @parent.nil?
    @parent.balance
  end

  def update_height
    l_height = @left.nil? ? 0 : @left.height
    r_height = @right.nil? ? 0 : @right.height
    @height = ((l_height > r_height) ? l_height : r_height) + 1
    @parent.update_height unless @parent.nil?
  end

  def update_children_count
    left_count = @left.nil? ? 0 : (@left.children_count + @left.occurrences)
    right_count = @right.nil? ? 0 : (@right.children_count + @right.occurrences)
    @children_count = left_count + right_count
    @parent.update_children_count unless @parent.nil?
  end

  def rotate
    if difference >= BAL_H
      #check if children should rotate too
      @right.rotate if @right.difference <= -BAL_H
      rotate_left
    elsif difference <= -BAL_H
      #check if children should rotate too
      @left.rotate if @left.difference >= BAL_H
      rotate_right
    end
  end

  def rotate_left
    #the old right is now the root
    root = @right
    root.parent = @parent
    #update the parent to point to the new root
    unless @parent.nil?
      if @parent.right == self
        @parent.right = root
      else
        @parent.left = root
      end
    end

    #this node's right is now the root's left
    @right = root.left
    root.left.parent = self unless root.left.nil?

    #the root is now the parent of this node
    @parent = root
    #this node is now the root's left
    root.left = self
    root.left.update_height
    root.left.update_children_count
    root
  end

  def rotate_right
    root = @left
    root.parent = @parent
    #update the parent to point to the new root
    unless @parent.nil?
      if @parent.right == self
        @parent.right = root
      else
        @parent.left = root
      end
    end

    @left = root.right
    root.right.parent = self unless root.right.nil?

    @parent = root
    root.right = self
    root.right.update_height
    root.right.update_children_count
    root
  end

  def difference
    r_height = @right.nil? ? 0 : @right.height
    l_height = @left.nil? ? 0 : @left.height
    r_height - l_height
  end
end

class InsertSort
  def number_of_swaps(input)
    # skip over the number of elements
    input.gets()
    array = input.gets().split.map { |n| n.to_i }
    tree = AVLTree.new
    result = 0

    while array.size > 0
      e = array.shift
      result += tree.insert(e)
    end

    result
  end
end

time = Benchmark.measure do
  input = STDIN
  #input = File.new("input03.txt", "r")
  number_of_test_cases = input.gets.chomp().to_i
  insert_sort = InsertSort.new

  number_of_test_cases.times do
    STDOUT.puts insert_sort.number_of_swaps(input)
  end
end