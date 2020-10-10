# frozen_string_literal: false

# Module that can be included (mixin) to take and output TSV data
module TsvBuddy
  def seperate_header_content(tsv)
    f = tsv.split("\n").map { |line| line.split("\t") }
    @header = f[0]
    @content = f[1..-1]
  end

  def create_yml_hash(row)
    yml_hash = {}
    row.each.with_index { |atr, index| yml_hash[@header[index]] = atr }
    yml_hash
  end

  # take_tsv: converts a String with TSV data into @data
  # parameter: tsv - a String in TSV format
  def take_tsv(tsv)
    seperate_header_content(tsv)
    @data = @content.map { |row| create_yml_hash(row) }
  end

  def write_header(row)
    row.each_key { |key| @tsv_string << "#{key}\t" }
    @tsv_string.gsub!(/\t$/, "\n")
  end

  def write_content(row)
    row.each_value { |value| @tsv_string << "#{value}\t"}
    @tsv_string.gsub!(/\t$/, "\n")
  end

  # to_tsv: converts @data into tsv string
  # returns: String in TSV format
  def to_tsv
    @tsv_string = ''
    write_header(@data[0])
    @data.each { |row| write_content(row) }
    @tsv_string
  end
end
