require 'gherkin/parser'
module RSpecGherkin
  class Builder
    attr_reader :features

    def self.build(file)
      parser = Gherkin::Parser.new
      token = Gherkin::TokenScanner.new(File.read(file))
      RSpecGherkin::Builder.new(parser.parse(token))
    end

    def initialize(feature_hash)
      @features ||= []
      @features << Feature.new(feature_hash)
    end
  end

  class Feature
    attr_reader :raw, :scenarios, :tags

    def initialize(raw)
      @raw = raw
      @scenarios = []
      @raw[:scenarioDefinitions].each do |raw_scenario|
        @scenarios << Scenario.new(raw_scenario)
      end
    end

    def tags
      @raw[:tags].map { |tag| tag[:name] }
    end

    def name
      @raw[:name]
    end

    def location
      @raw[:location]
    end

    def comments
      @raw[:comments]
    end
  end

  class Scenario
    attr_reader :raw, :steps, :tags, :examples

    def initialize(raw_scenario)
      @raw = raw_scenario
    end

    def name
      @raw[:name]
    end

    def tags
      @raw[:tags].map { |tag| tag[:name] }
    end

    def type
      @raw[:type]
    end

    def location
      @raw[:location]
    end

    def steps
      @raw[:steps]
    end

    def examples
      if type == :ScenarioOutline
        @raw[:examples].each { |raw_example| RSpecGherkin::Example.new(raw_example) }
      end
    end
  end

  class Example
    def initialize(raw_example)
      @raw = raw_example
    end


  end

end


# module RSpecGherkin
#   class Builder
#     module Tags
#       def tags
#         @raw.tags.map { |tag| tag.name.sub(/^@/, '') }
#       end
#
#       def tags_hash
#         Hash[tags.map { |t| [t.to_sym, true] }]
#       end
#
#       def metadata_hash
#         tags_hash
#       end
#     end
#
#     module Name
#       def name
#         @raw.name
#       end
#     end

#     class Feature
#       include Tags
#       include Name
#
#       attr_reader :scenarios, :backgrounds
#       attr_accessor :feature_tag
#
#       def initialize(raw)
#         @raw = raw
#         @scenarios = []
#         @backgrounds = []
#       end
#
#       def line
#         @raw.line
#       end
#     end
#
#     class Background
#       def initialize(raw)
#         @raw = raw
#       end
#     end
#
#     class Scenario
#       include Tags
#       include Name
#
#       attr_accessor :arguments
#
#       def initialize(raw)
#         @raw = raw
#         @arguments = []
#       end
#     end
#
#     class Step < Struct.new(:description, :extra_args, :line)
#       # 1.9.2 support hack
#       def split(*args)
#         self.to_s.split(*args)
#       end
#
#       def to_s
#         description
#       end
#     end
#
#     attr_reader :features
#
#     class << self
#       def build(feature_file)
#         RSpecGherkin::Builder.new.tap do |builder|
#           parser = Gherkin::Parser::Parser.new(builder, true)
#           parsed_feature = parser.parse(File.read(feature_file), feature_file, 0)
#           @features ||= []
#           @features << parsed_feature
#         end
#       end
#     end
#
#     def initialize
#       @features = []
#     end
#
#     def background(background)
#       @current_step_context = Background.new(background)
#       @current_feature.backgrounds << @current_step_context
#     end
#
#     def feature(feature)
#       @current_feature = Feature.new(feature)
#       @features << @current_feature
#     end
#
#     def scenario(scenario)
#       @current_step_context = Scenario.new(scenario)
#       @current_feature.scenarios << @current_step_context
#     end
#
#     def scenario_outline(outline)
#       @current_scenario_template = outline
#     end
#
#     def examples(examples)
#       rows_to_array(examples.rows).each do |arguments|
#         scenario = Scenario.new(@current_scenario_template)
#         scenario.arguments = arguments.map do |argument|
#           if numeric?(argument)
#             integer?(argument) ? argument.to_i : argument.to_f
#           elsif boolean?(argument)
#             to_bool(argument)
#           else
#             argument
#           end
#         end
#
#         @current_feature.scenarios << scenario
#       end
#     end
#
#     def step(*)
#     end
#
#     def uri(*)
#     end
#
#     def eof
#     end
#
#     private
#
#     def integer?(string)
#       return true if string =~ /^\d+$/
#     end
#
#     def numeric?(string)
#       return true if string =~ /^\d+$/
#       true if Float(string) rescue false
#     end
#
#     def boolean?(string)
#       string =~ (/(true|t|yes|y)$/i) ||
#           string =~ (/(false|f|no|n)$/i)
#     end
#
#     def to_bool(string)
#       return true if string =~ (/(true|t|yes|y|1)$/i)
#       return false if string =~ (/(false|f|no|n|0)$/i)
#     end
#
#     #TODO Need to come up with better handling of support for JRuby
#     def rows_to_array(rows)
#       if RUBY_PLATFORM =~ /java/
#         rows.map { |row| row.cells }.drop(1)
#       else
#         rows.map { |row| row.cells(&:value) }.drop(1)
#       end
#     end
#
#   end
# end
