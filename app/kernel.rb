# The operations on the LWW Element Set are:
#   New() → Z
#   Add(Z, e, t)
#   Remove(Z, e, t)
#   Exists(Z, e) → boolean
#   Get(Z) → array
#
# Usage:
# irb -r ./app.rb
#
# Z = New()
# Add(Z, 'apple', 123122)
# Add(Z, 'orange', 123100)
# Remove(Z, 'apple', 124900)
# Exists(Z, 'apple')  -> false
# Get(Z)              -> ['orange']
#
#
module Kernel

  private

  # New() → Z
  def New()
    LWWSet.new(store: :memory)
  end

  # Add(Z, e, t)
  def Add(lww_set, element, time)
    lww_set.add(element, time)
    nil
  end

  # Remove(Z, e, t)
  def Remove(lww_set, element, time)
    lww_set.remove(element, time)
    nil
  end

  # Exists(Z, e) → boolean
  def Exists(lww_set, element)
    lww_set.exists?(element)
  end

  # Get(Z) → array
  def Get(lww_set)
    lww_set.get
  end
end