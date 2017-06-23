require 'CSV'
require_relative 'indenty-config.rb'
require_relative 'level.rb'

def levels_from_csv(filename)
	# Read the data from the CSV file and turn it into an array
	levels = []
	csv_data = CSV.read(filename)

	csv_data.each do |line|
		current_level = Level.new
		current_level.text = line[0]
		current_level.indent = line[1]
		levels.push(current_level)
	end

	return levels
end

def write_line_to_csv(filename, mode, line_data)
	# Write the line data to the csv file.
	open(filename, mode) do |f|
		f << line_data
	end
end

def main
	# Get the configuration settings
	config = IndentyConfig.new

	# Levels is an array where each element is a pair of values:
	# 	- a hiearchy member and its indent level
	levels = levels_from_csv( config.source_filename )

	# This array will be filled with the hiearchy values from a single line.
	# They are placed in the slots based on their relation to each other.
	indent_levels = [nil, nil, nil, nil, nil, nil]

	# Iterate through one line of the source data at a time.
	levels.each do |level|
		# Keep track of the current level of the hiearchy as a rank and 0-start index.
		current_indent_level = level.indent.to_i
		current_indent_level_as_index = current_indent_level - 1

		# Read the value and place it in the correct slot, based on its indention
		indent_levels[current_indent_level - 1] = level.text

		# Clear any values below current indent level
		indent_levels.size.times do |index|
			if(index > current_indent_level_as_index)
				indent_levels[index] = ''
			end
		end

		# Display the current line values to the user
		p indent_levels

		# Start building the output string
		output_string = ''

		# Add one hiearchy element of the line at a time, adding commas between.
		indent_levels.each_with_index do |element, index|
			output_string += element.to_s
			output_string += ',' unless (indent_levels.size - 1) == index
		end

		# Add new line character to end of line
		output_string += "\n"

		# Write current line to CSV file
		write_line_to_csv(config.output_filename, 'a', output_string)
	end

end

main
