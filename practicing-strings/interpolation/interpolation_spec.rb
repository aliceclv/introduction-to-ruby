require 'open3'
require_relative 'main'

describe 'interpolate name' do
  let(:file_content) { File.open('./main.rb').read }
  let(:name_regexp) { Regexp.new(/first_name = ("|')(.*)("|')/) }
 
 it 'should define a first_name variable' do
    expect(file_content).to match(name_regexp)
  end

  it 'first_name should not be empty or nil' do
    name = file_content.match(name_regexp)&.values_at(2)&.pop
    expect(name).not_to be_nil && be_empty
  end

  it 'should output string with interpolated name' do
    result = Open3.popen2('ruby ./main.rb') do |i, o, th|
      o.read
    end
    name = name_regexp.match(file_content)&.values_at(2)&.pop
    expect(result).to match(/Hi #{name}, ready to master the Ruby programming language?/)
  end
end