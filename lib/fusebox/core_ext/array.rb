class Array

  # Return an ASCII table for an array of hashes
  # @example
  #     [{:a => "Uno", :b => "Dos"}, {:a => "Ichi", :b => "Ni"}].to_ascii_table([:a, :b], %w(One Two))
  # @param [Array<Symbol>] keys Which keys to display, in order
  # @param [Array<Symbol>] labels Column headings for the keys
  # @return [String]
  def to_ascii_table (keys, labels)
    raise ArgumentError, "`labels` length does not match `keys` length" if keys.length != labels.length
    return '' if self.length == 0
    raise ArgumentError, "expected elements to be Hash instances; instead received: #{first.inspect}" unless first.is_a?(Hash)

    widths = keys.map do |key|
      ([Hash[keys.zip(labels)]] + self).map { |row| row[key].to_s.length }.max
    end

    text = ''

    text += to_ascii_table_hr(widths)

    labels.each_with_index do |key, i|
      text += "| " + labels[i].ljust(widths[i] + 1)
    end
    text += "|\n"

    text += to_ascii_table_hr(widths)

    each do |row|
      keys.each_with_index do |key, i|
        text +=  "| " + row[key].ljust(widths[i] + 1)
      end
      text +=  "|\n"
    end

    text += to_ascii_table_hr(widths)
    text
  end

protected
  # Print a horizonal divider calc
  # @param [Array<Fixnum>] widths List of column widths
  def to_ascii_table_hr(widths)
    '+' + '-' * (widths.inject(&:+) + widths.length * 3 - 1 ) + "+\n"
  end

end