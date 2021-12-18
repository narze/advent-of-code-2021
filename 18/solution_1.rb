class Node
  attr_accessor :left, :right, :value

  def initialize(data)
    if data.is_a?(Array)
      @left = Node.new data.first
      @right = Node.new data.last
    else
      @value = data
    end
  end

  def get
    if edge?
      value
    else
      [@left.get, @right.get]
    end
  end

  def edge?
    !value.nil?
  end

  def +(other)
    Node.new([get, other.get])
  end

  def edge_nodes
    if edge?
      return self
    else
      return [left.edge_nodes, right.edge_nodes].flatten
    end
  end

  def magnitude
    if edge?
      value
    else
      [left.magnitude * 3, right.magnitude * 2].sum
    end
  end
end

def reduce_once(node)
  @changed = false
  edge_nodes = node.edge_nodes
  p edge_nodes.map &:value

  def traverse(node, edge_nodes, mode, depth=0)
    return if @changed

    if node.edge?
      if node.value >= 10 && mode == :split
        left_val = node.value / 2
        right_val = node.value - left_val
        node.left = Node.new(left_val)
        node.right = Node.new(right_val)
        node.value = nil
        @changed = true
      end
    else
      if depth >= 4 && mode == :explode
        left_idx = edge_nodes.index(node.left)
        right_idx = edge_nodes.index(node.right)
        if left_idx && left_idx > 0
          left = edge_nodes[left_idx - 1]
          left.value += node.left.value
        end
        if right_idx && (right = edge_nodes[right_idx + 1])
          right.value += node.right.value
        end
        node.value = 0
        node.left = nil
        node.right = nil
        @changed = true
      else
        traverse(node.left, edge_nodes, mode, depth + 1)
        traverse(node.right, edge_nodes, mode, depth + 1)
      end
    end
  end

  traverse(node, edge_nodes, :explode)
  traverse(node, edge_nodes, :split)

  @changed
end

def reduce(node)
  while reduce_once(node); end

  node
end


def run_test
  tree = Node.new([[[[4, 3], 4], 4], [7, [[8, 4], 9]]])

  # Data
  assert(tree.get, [[[[4, 3], 4], 4], [7, [[8, 4], 9]]])
  assert(tree.left.get, [[[4, 3], 4], 4])
  assert(tree.right.get, [7, [[8, 4], 9]])

  # Addition
  assert((Node.new([1, 2]) + Node.new([[3, 4], 5])).get, [[1, 2], [[3, 4], 5]])

  # Edge nodes
  assert(tree.edge_nodes.map(&:value), [[[[4, 3], 4], 4], [7, [[8, 4], 9]]].flatten)

  # Reduce
  x = [[[[4, 3], 4], 4], [7, [[8, 4], 9]]]
  y = [1, 1]
  expected = [[[[0, 7], 4], [[7, 8], [6, 0]]], [8, 1]]
  assert(expected, reduce(Node.new(x)+Node.new(y)).get)

  x = [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
  y = [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
  expected = [[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]
  assert(expected, reduce((Node.new(x))+(Node.new(y))).get)

  x = [[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]
  y = [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
  e = [[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]
  assert(e, reduce(Node.new(x) + Node.new(y)).get)

  x = [[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]
  y = [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
  e = [[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]
  assert(e, reduce(Node.new(x) + Node.new(y)).get)

  x = [[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]
  y = [7,[5,[[3,8],[1,4]]]]
  e = [[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]
  assert(e, reduce(Node.new(x) + Node.new(y)).get)

  x = [[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]
  y = [[2,[2,2]],[8,[8,1]]]
  e = [[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]
  assert(e, reduce(Node.new(x) + Node.new(y)).get)

  x = [[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]
  y = [2,9]
  e = [[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]
  assert(e, reduce(Node.new(x) + Node.new(y)).get)

  x = [[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]
  y = [1,[[[9,3],9],[[9,0],[0,7]]]]
  e = [[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]
  assert(e, reduce(Node.new(x) + Node.new(y)).get)

  x = [[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]
  y = [[[5,[7,4]],7],1]
  e = [[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]
  assert(e, reduce(Node.new(x) + Node.new(y)).get)

    x = [[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]
  y = [[[[4,2],2],6],[8,7]]
  e = [[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]
  assert(e, reduce(Node.new(x) + Node.new(y)).get)

  # Reduce lines
  lines = [
    [[[0, [4, 5]], [0, 0]], [[[4, 5], [2, 6]], [9, 5]]],
    [7, [[[3, 7], [4, 3]], [[6, 3], [8, 8]]]],
    [[2, [[0, 8], [3, 4]]], [[[6, 7], 1], [7, [1, 6]]]],
    [[[[2, 4], 7], [6, [0, 5]]], [[[6, 8], [2, 8]], [[2, 1], [4, 5]]]],
    [7, [5, [[3, 8], [1, 4]]]],
    [[2, [2, 2]], [8, [8, 1]]],
    [2, 9],
    [1, [[[9, 3], 9], [[9, 0], [0, 7]]]],
    [[[5, [7, 4]], 7], 1],
    [[[[4, 2], 2], 6], [8, 7]]
  ]

  n = Node.new(lines.first)

  lines[1..].each do |l|
    n += Node.new(l)
    reduce(n)
    p n.get
  end

  assert([[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]], n.get)

  # Magnitude
  # [[1,2],[[3,4],5]] becomes 143.
  assert(Node.new([[1,2],[[3,4],5]]).magnitude, 143)
  # [[[[0,7],4],[[7,8],[6,0]]],[8,1]] becomes 1384.
  assert(Node.new([[[[0,7],4],[[7,8],[6,0]]],[8,1]] ).magnitude, 1384)
  # [[[[1,1],[2,2]],[3,3]],[4,4]] becomes 445.
  assert(Node.new([[[[1,1],[2,2]],[3,3]],[4,4]]).magnitude, 445)
  # [[[[3,0],[5,3]],[4,4]],[5,5]] becomes 791.
  assert(Node.new([[[[3,0],[5,3]],[4,4]],[5,5]]).magnitude, 791)
  # [[[[5,0],[7,4]],[5,5]],[6,6]] becomes 1137.
  assert(Node.new([[[[5,0],[7,4]],[5,5]],[6,6]] ).magnitude, 1137)
  # [[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]] becomes 3488.
  assert(Node.new([[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]] ).magnitude, 3488)

  puts ' All Tests Passed'
end

def assert(expected, actual)
  if expected == actual
    print 'P'
  else
    puts "Expected: #{expected}"
    puts "Actual: #{actual}"
    raise 'FAILED'
  end
end

def run
  input = File.read(ARGV[0]).split("\n").map { |l| eval l }

  ans = input.reduce do |acc, line|
    acc = Node.new(acc) unless acc.is_a?(Node)
    reduce(acc + Node.new(line))
  end

  puts "Magnitude : #{ans.magnitude}"
end

run_test

run
