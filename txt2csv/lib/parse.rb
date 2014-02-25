# this class is to parse out name, phone, email and twitter data.
class Parse
  def initialize (prefix, suffix, input, output)
    @prefix = prefix
    @suffix = suffix
    @input = input
    @output = output
  end

  def name_pull
    parsed_names = []
    IO.foreach(@input) { |line| parsed_names << line.scan(/[^\t\n]+/)[0] }
    parsed_names
  end

  def pre_array
    prefix_array = []
    IO.foreach(@prefix) { |line| prefix_array << line.scan(/^\S*/)[0] }
    prefix_array
  end

  def suf_array
    suffix_array = []
    IO.foreach(@suffix) { |line| suffix_array << line.scan(/^\S*/)[0] }
    suffix_array
  end

  def self.parse_names(prefix_array, suffix_array, parsed_names)
    parsed_name = { pre: '', first: '', middle: '', last: '', suffix: '' }
    word = name_string.split
    parsed_name[:suffix] = word.pop if suffixes.include? word.last
    parsed_name[:last] = word.pop
    parsed_name[:pre] = word.shift if prefixes.include? word.first
    parsed_name[:first] = word.shift || word[0] = ''
    parsed_name[:middle] = word.shift || word[0] = ''
    parsed_name.values
  end

  def self.parse_twitter(data)
    twitter = /\w+/
    [twitter.match(data).to_s]
  end

  def self.parse_email(eaddress)
    email = /\w+\@\w+\.\w+/
    email.match(eaddress) ? [email.match(eaddress).to_s] : ['Not Found']
  end

  def self.parse_numbers(numbers)
    parse_number = {  country: '', area: '', prefix: '', line: '', ext: '' }
    num = numbers.scan(/\d+/)
    parse_number[:country] = num.shift if num[0] == '1'
    parse_number[:area] = num.shift
    parse_number[:prefix] = num.shift
    parse_number[:line] = num.shift
    parse_number[:ext] = num.shift || num[0] = ''
    parse_number.values
  end
end
