require 'spec_helper'
require_relative '../lib/parse'

describe 'outputs CSV file' do
  it 'should output a valid CSV file' do
    `./bin/txt2csv convert -p prefix.txt -s suffix.txt -i raw_customers2.txt -o spec/test_csv.txt`
    IO.read('spec/Convertoutput.csv') == IO.read('spec/test_csv.txt')
  end

  after(:all) do
    File.delete('spec/test_csv.txt')
  end
end
