# this class is to parse out name, phone, email and twitter data.
class Parse
  def initialize (prefile, suffile, input, output)
    @prefile = prefile
    @suffile = suffile
    @input = input
    @output = output
  end

  def output
    CSV.open(@outfile, "w", :write_headers =>true,
      :headers =>['pre', 'first', 'middle', 'last', 'country',
       'area', 'phonepre', 'line', 'ext', 'twit', 'email']) do |csv|
      
      IO.foreach(@infile) do |line| 
        name_string = Parse.parse_names(pre_array, suf_array,line.scan(/[^\t\n]+/)[0])
        phone_string = Parse.parse_numbers(line.scan(/[^\t\n]+/)[1])
        twit_string = Parse.parse_twitter(line.scan(/[^\t\n]+/)[2])
        email_string = Parse.parse_email(line.scan(/[^\t\n]+/)[3])
        csv << name_string + phone_string + twit_string + email_string
      end   
    end
  end

  def pre_array
    prefix_array = []
    IO.foreach(@prefile) { |line| prefix_array << line.scan(/^\S*/)[0] }
    prefix_array
  end

  def suf_array
    suffix_array = []
    IO.foreach(@suffile) { |line| suffix_array << line.scan(/^\S*/)[0] }
    suffix_array
  end



  def self.parse_names(prefixes, suffixes, name_string)
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
