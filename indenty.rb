require 'CSV'
require_relative 'level.rb'

def main
	filename = 'source-data.csv'
	csv_data = CSV.read(filename)
	levels = []
	output_lines = []

	csv_data.each do |line|
		current_level = Level.new
		current_level.text = line[0]
		current_level.indent = line[1]
		levels.push(current_level)
	end

	indent_levels = [nil, nil, nil, nil, nil, nil]

	levels.each do |level|
		current_indent_level = level.indent.to_i
		current_indent_level_as_index = current_indent_level - 1

		indent_levels[current_indent_level - 1] = level.text

		# clear any values below current indent level
		indent_levels.size.times do |index|
			if(index > current_indent_level_as_index)
				indent_levels[index] = ''
			end
		end

		p indent_levels
		output_string = ''

		indent_levels.each_with_index do |element, index|
			output_string += element.to_s
			output_string += ',' unless (indent_levels.size - 1) == index
		end

		output_string += "\n"

		open('output.csv', 'a') do |f|
			f << output_string
		end
	end

end

main
