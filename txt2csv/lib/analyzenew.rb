
#this is to make the analyze command in thor work
class Analyze
  def initialize(option, input, output)
    @option = option
    @input = input
    @output_file = output
    @regex = regex
  end

  def name_pull
    parsed_names = []
    IO.foreach(@input) { |line| parsed_names << line.scan(/[^\t\n]+/)[0] }
    parsed_names
  end

  def regex
    case @option
    when :prefix
      regular_expression = /^\S*/
    when :suffix
      regular_expression = /\S*$/
    else
      puts "unknown option"
    end
  end

  def histogram(parsed_names)
    histogram = Hash.new(0)

    parsed_names.each do |name_string|
      word = @regex.match(name_string).to_s
      histogram[word.to_sym] += 1
    end
    Hash[histogram.sort_by { |name, count| count }.reverse]
  end

  def output_file(histogram)
    File.open(@output_file, "w+") do |file|
      histogram.each { |name, count| file.puts "#{name} #{count}" }
    end
  end
end