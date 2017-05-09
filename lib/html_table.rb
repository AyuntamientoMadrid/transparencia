require 'nokogiri'

class HTMLTable
  include Enumerable

  def each
    ([head_row] + rows).each do |row|
      yield(row)
    end
  end

  def initialize(io)
    @doc = Nokogiri::HTML(io)
  end

  def self.open(io_or_path)
    if io_or_path.respond_to? :seek
      new(io_or_path)
    else
      File.open(io_or_path, 'rb+') do |f|
        new(f)
      end
    end
  end

  def head_row
    @head_row ||= @doc.xpath('//table/thead/tr/th').map(&:text)
  end

  def rows
    @rows ||= @doc.xpath('//table/tbody/tr').map do |row|
      row.xpath('td').map do |td|
        text = td.text
        text =~ /^(\d)+$/ ? text.to_i : text
      end
    end
  end
end
