Maybe = Algebrick.type do
  variants None = atom,
           Some = type { fields Object }
end

# Types can be extended with usual syntax for modules and using Ruby supports module reopening.
module Maybe
  def maybe(&block)
    case self
    when None
    when Some
      block.call value
    end
  end
end #

# #maybe method is defined on both values (None, Some) of Maybe.
None.maybe { |_| raise 'never ever happens' }
# Block is called with the value.
Some[1].maybe { |v| v*2 }

# It also works as expected when modules like Comparable are included.
Season = Algebrick.type do
  variants Spring = atom,
           Summer = atom,
           Autumn = atom,
           Winter = atom
end

module Season
  include Comparable
  ORDER = Season.variants.each_with_index.each_with_object({}) { |(season, i), h| h[season] = i }

  def <=>(other)
    Type! other, Season
    ORDER[self] <=> ORDER[other]
  end
end #

Quarter = Algebrick.type do
  fields! year: Integer, season: Season
end

module Quarter
  include Comparable

  def <=>(other)
    Type! other, Quarter
    [year, season] <=> [other.year, other.season]
  end
end #

# Now Quarters and Seasons can be compared as expected.
[Winter, Summer, Spring, Autumn].sort
Quarter[2013, Spring] < Quarter[2013, Summer]
Quarter[2014, Spring] > Quarter[2013, Summer]
Quarter[2014, Spring] == Quarter[2014, Spring]
[Quarter[2013, Spring], Quarter[2013, Summer], Quarter[2014, Spring]].sort



