class IndentyConfig
  attr_reader :source_filename, :output_filename

  def initialize
    @source_filename = 'source-data.csv'
    @output_filename = 'output.csv'
  end
end
