class Cave
  attr_reader :water_units

  def initialize(rows)
    @rows = rows
    water_positions = positions_from_bottom_right.select { |x, y| at(x, y) == :water }
    @water_units = water_positions.size
    @entry_point = water_positions.last
  end

  def at(x, y)
    @rows[y][x]
  end

  def rows
    @rows.dup
  end

  def pump
    positions_from_bottom_right.each do |x, y|
      flow_at(x, y)
    end
    set_at(*@entry_point, :water)
    @water_units += 1
  end

  def self.parse(input)
    rows = input.split("\n").map(&:strip).map do |line|
      line.chars.map do |char|
        {"#" => :rock, " " => :air, "~" => :water}[char]
      end
    end
    new(rows)
  end

  def to_s
    @rows.map do |row|
      row.map do |square|
        {:rock => "#", :air => " ", :water => "~"}[square]
      end.join
    end.join("\n") + "\n"
  end

  private

  def flow_at(x, y)
    return unless at(x, y) == :water
    if at(x, y + 1) == :air
      set_at(x, y + 1, :water)
      set_at(x, y, :air)
    elsif at(x + 1, y) == :air && at(x, y + 1) != :air
      set_at(x + 1, y, :water)
      set_at(x, y, :air)
    end
  end

  def set_at(x, y, thing)
    @rows[y][x] = thing
  end

  def positions_from_bottom_right
    Enumerator.new do |enum|
      (@rows.first.size - 1).downto(0).each do |x|
        (@rows.size - 1).downto(0).each do |y|
          enum << [x, y]
        end
      end
    end
  end
end

