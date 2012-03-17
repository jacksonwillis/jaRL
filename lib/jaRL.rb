#!/usr/bin/env ruby

module Jarl
  class Data
    attr_accessor :data

    def initialize(data)
      @data = data
    end

    def to_s
      @data.to_s
    end

    def to_ruby
      @data
    end
  end

  class Numeric < Data
    def initialize(str)
      @data = Float(str)
    end

    def inspect
      "<jarl Numeric: #{@data.inspect}>"
    end
  end

  class Symbol < Data
    def initialize(str)
      @data = str.to_sym
    end

    def inspect
      "<jarl Symbol: #{@data.inspect}>"
    end
  end

  class String < Data
    def initialize(str = "")
      @data = str
    end

    def <<(other)
      @data += other.to_s
    end

    def inspect
      "<jarl String: #{@data.inspect}>"
    end
  end

  module Parser
    def literals
      {
        /[\w\+\-\*\/=]+/ => :symbol,
        /\d+(\.\d+)?/ => :numeric
      }
    end

    def tokens
      {
        /\(/ => :expr_open,
        /\)/ => :expr_close,
        /\'/ => :str
      }
    end

    def tokenize_syntax(str)
      no_comments = ignore_comments(str)
      token_split = no_comments.split(/(\s|#{tokens.keys.join("|")})/)
      token_split.map { |s| token_replace(s) }
    end

    def ignore_comments(str)
      str.gsub(/#.*$/, '')
    end

    def token_replace(str)
      tokens.each do |regex, name|
        return name if str =~ regex
      end

      str
    end

    def tokenize_strings(args)
      expr_list = []
      str_open = false

      args.each do |a|
        if a == :str
          str_open = !str_open
          next
        end

        if str_open
          expr_list << Jarl::String.new unless expr_list.last.is_a? Jarl::String
          expr_list.last << a
        else
          expr_list << a
        end
      end

      expr_list
    end

    def eval(arr)
      #
    end

    def tokenize_numerics(args)
      args.map { |a| (a =~ /^#{literals.key(:numeric)}$/) ? Jarl::Numeric.new(a) : a }
    end

    def tokenize_symbols(args)
      args.map { |a| (a.respond_to?(:to_str) && a =~ /^#{literals.key(:symbol)}$/) ? Jarl::Symbol.new(a.to_s) : a }
    end

    def tokenize_literals(args)
      tokenize_symbols(tokenize_numerics(tokenize_strings(args))).delete_if { |a| a =~ /^\s*$/ }
    end

    def tokenize(str)
      tokenize_literals(tokenize_syntax(str))
    end

    def parse(str)
      tokens_to_lispy_ruby(tokenize(str))
    end

    def tokens_to_lispy_ruby(list)
      result = []

      while list.any?
        case (item = list.shift)
        when :expr_open
          result.push(tokens_to_lispy_ruby(list))
        when :expr_close
          return result
        else
          result.push(item)
        end
      end

      return result
    end

    extend self
  end
end

if __FILE__ == $0

[
"(a (b 1 2) (c 3 4))",
#"
#(if
# (= (+ 2 2) 5)
#  (println 'WUT.')    # will never be called
#  (println 'WOrks!'))
#
#(some-function)
#",

"(println 3.14 ' is the value of pi')"

].each do |input|
  #puts input, "\n"
  #p Jarl::Parser.parse(input)
  #puts "\n--------\n\n"
end

end
