def ahead_of_snake(snake, direction)
  [snake.last[0] + direction[0], snake.last[1] + direction[1]]
end

def move(snake, direction)
  snake.dup[1..-1].push(ahead_of_snake(snake, direction))
end

def grow(snake, direction)
  snake.dup.push(ahead_of_snake(snake, direction))
end

def new_food(food, snake, dimensions)
  new_food_set = [*0...dimensions[:width]].product([*0...dimensions[:height]])
  (new_food_set - (snake | food)).sample
end

def obstacle_ahead?(snake, direction, dimensions)
  new_element = ahead_of_snake(snake, direction)

  check_height = new_element[1] >= dimensions[:height] || new_element[1] < 0
  check_width = new_element[0] >= dimensions[:width] || new_element[0] < 0
  check_width || check_height || snake.include?(new_element)
end

def danger?(snake, direction, dimensions)
  new_snake = move(snake, direction)
  check_first_move = obstacle_ahead?(snake, direction, dimensions)
  check_second_move = obstacle_ahead?(new_snake, direction, dimensions)

  check_first_move || check_second_move
end
