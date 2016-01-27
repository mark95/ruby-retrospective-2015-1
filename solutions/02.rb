def move(snake, direction)
  new_snake = snake.dup
  new_element = [snake.last[0] + direction[0], snake.last[1] + direction[1]]
  new_snake.shift
  new_snake << new_element
end

def grow(snake, direction)
  new_snake = snake.dup
  new_element = [snake.last[0] + direction[0], snake.last[1] + direction[1]]
  new_snake << new_element
end

def new_food(food, snake, dimensions)
  width_set = (0..dimensions[:width] - 1).to_a
  height_set = (0..dimensions[:height] - 1).to_a

  new_food_set = width_set.product(height_set) - snake - food
  (new_food_set.shuffle).first
end

def obstacle_ahead?(snake, direction, dimensions)
  new_element = [snake.last[0] + direction[0], snake.last[1] + direction[1]]

  check_height = new_element[1] >= dimensions[:height] || new_element[1] < 0
  check_width = new_element[0] >= dimensions[:width] || new_element[0] < 0
  check_width || check_height || snake.include?(new_element) ? true : false
end

def danger?(snake, direction, dimensions)
  new_snake = move(snake, direction)
  check_first_move = obstacle_ahead?(snake, direction, dimensions)
  check_second_move = obstacle_ahead?(new_snake, direction, dimensions)

  check_first_move || check_second_move ? true : false
end
