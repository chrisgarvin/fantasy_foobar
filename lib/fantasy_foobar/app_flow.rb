def add_players?
  input = ''
  while !input.casecmp('y').zero? && !input.casecmp('n').zero?
    printf 'Would you like to add players to your team? (y/n) '
    input = gets.chomp
  end

  input == 'y'
end

def remove_players?
  input = ''
  while !input.casecmp('y').zero? && !input.casecmp('n').zero?
    printf 'Would you like to remove players from your team? (y/n) '
    input = gets.chomp
  end

  input == 'y'
end

def update_team?
  print_current_team

  input = ''
  while !input.casecmp('y').zero? && !input.casecmp('n').zero?
    printf 'Would you like to update your current team? (y/n) '
    input = gets.chomp
  end

  input == 'y'
end
