require 'pry-byebug'

# The goal is to create a program that generates a
# valid combination of observers and participants across rooms

# Say we have

# 6 Observers
# 3 Participants
# 3 Exercises

# EX 1

# [01 02] # [03 04] # [05 06]
# [ P1 ]  # [ P2 ]  # [ P3 ]

# EX 2

# [01 02] # [03 04] # [05 06]
# [ P1 ]  # [ P2 ]  # [ P3 ]

# EX 3

# [01 02] # [03 04] # [05 06]
# [ P1 ]  # [ P2 ]  # [ P3 ]

# We need to build a matrix

# -> Ensures all observers see all participants at least once
# -> Ensures no observer sees a participant more than twice


# Can we solve it with dynamic programming?
class Exercise
  def initialize(ex_number)
    ex_number = ex_number
    @rooms = []
  end
end

class Room
  attr_accessor :exercise

  def initialize
    @room_no = nil
    @observers = []
    @participant = nil
  end

  def add_observer(obs)
    @observers << obs
  end

  def add_participant(part)
    @participant = part
  end
end

def generate_matrix(rooms)
  # create 3 exercises with their rooms
  rooms.each do |room|
    until is_full?(room)
      if is_safe?(room, rooms)
        room.add_observer
      end
    end
  end

  # Place an observer

end

# 1) Start in the first room

# 2) If all observers and participants have are placed
#     return true

# 3) Try all rooms in the current exercise.
#    Do following for every tried room.
#     a) If the an observer can be placed safely in this room
#        then mark this [room and exercise] as part of the
#        solution and recursively check if placing
#        observers from this point on leads to a solution.
#     b) If placing an observer in this room and exercise leads to
#        a solution then return true.
#     c) If placing queen doesn't lead to a solution then
#        unmark this room and exercise (Backtrack) and assign a different observer.

# 3) If all rooms have been populated with observers and nothing worked,
#    return false to trigger backtracking.


# --------------------------------

# What if I try to break the problem down a bit, I feel I am a bit stuck with
# the notion of adding observers and participants within an room and within an
# exercise, the different levels of nesting make thinking about recursion a bit
# more difficult

# Let's try to think of an easier, cleaner user case.

# I have four observers across four rooms.

# Observers
# [1,2,3,4]

# Rooms
# [[], [], [], []]

# I want each room to have pairs of two observers.
# However,
# Observer 1 can never be with observer 3
# Observers are unique
# Observers can only pair once. No repetitions

# A possible solution could be

# [ [1, 2] [ 2, 3], [1, 4], [4, 3] ]

# let's try this first using backtracking

def full?(rooms)
  # all rooms should have two observers
  rooms.all? { |r| r.length == 2 }
end

def allocate!(rooms, obs)
  next_room = rooms.find { |r| r.length < 2 }
  next_room << obs
end

def deallocate!(rooms)
  rooms.reject { |r| r.empty? }.last.pop
end


def repeated_obs?(rooms)

  return false if rooms.none? { |r| r.length == 2 }
  return false if rooms.one? { |r| r.length == 2 }

  sorted_rooms = rooms.reject { |r| r.empty? || r.length == 1 }.map(&:sort)

  sorted_rooms.length != sorted_rooms.uniq.length
end

def is_safe?(rooms)
  # rooms are not valid if observer 1 and observer 3 are together
  if rooms.any? { |r| r.include?(1) && r.include?(3) }
    return false
  end

  # rooms are not valid if any of the rooms has a repeated observer
  if rooms.any? { |r| r.uniq.length < r.length }
    return false
  end

  def next_possible(rooms)
    last_room = rooms.find { |r| r.length == 1 }
    last_room[0] += 1
  end

  # rooms are not valid if there is a repeated observer-observer pair
  if repeated_obs?(rooms)
    return false
  end

  return true
end

def solve(rooms, first_obs = 1, last_obs = 4)


  # binding.pry


  # Return the rooms when all observers have been allocated
  # binding.pry if rooms == [[1, 2], [1, 4], [], []]

  return rooms if full?(rooms)

  # try all the possible observers for each of the rooms
  (first_obs..last_obs).each_with_index do |obs|
    allocate!(rooms, obs)
    # check the boundary conditions
    if is_safe?(rooms)
      return solve(rooms)
    else
      if obs == last_obs
        # Now I have a problem.
        # I tried to allocate the last obs and it was not valid.
        # This will only happen when I have a couple
        deallocate!(rooms)
        next_possible(rooms)

        return solve(rooms)
      end
      deallocate!(rooms)
      return solve(rooms, first_obs + 1 , 4)
    end
  end



end


p solve([[], [], [], [], []])
