# Allow RSpec assertions over the elements of a collection.  For example:
#
#   collection.should all_be > 0
#
# will specify that each element of the collection should be greater
# than zero.  Each element of the collection that fails the test will
# be reported in the error message.
#
# Examples:
#   [1,1,1].should all_be eq(1)
#   [2,4,6].should all_be_even
#   [3,6,9].should all_be_divisible_by(3)
#   [1,1,1].should all_be == 1
#   [2,3,5].should all_be { |n| prime?(n) }
#
# (for appropriate definitions of prime? and divisible_by?)
#
module RSpec
  module Matchers

    # Helper functions gathered here to avoid global name space
    # pollution.
    module AllBe
      module_function

      # Format a predicate function (with option arguments) for human
      # readability.
      def format_predicate(pred, *args)
        message_elements =
          ["be #{pred.gsub(/_/, ' ')}"] +
          args.map { |a| a.inspect }
        message_elements.join(' ')
      end

      # Create a collection matcher using +block+ as the matching
      # condition.  Block should take one or two arguments:
      #
      #   lambda { |element| ... }
      #   lambda { |element, messages| ... }
      #
      # If a block wishes to use custom failure messages, it should
      # append the message to the +messages+ array.  Otherwise we will
      # format an appropriate error message for each failing element.
      #
      def make_matcher(condition_string, &block)
        Matcher.new :all_be, block do |_block_|
          @failing_messages = []
          @broken = []
          match do |actual|
            actual.each do |element|
              unless _block_.call(element, @failing_messages)
                @broken << element
              end
            end
            @broken.empty?
          end

          failure_message_for_should do |actual|
            messages = ["in #{actual.inspect}:"]
            if @failing_messages.empty?
              messages += @broken.map { |element| "expected #{element.inspect} to #{condition_string}" }
            else
              messages += @failing_messages
            end
            messages.join("\n")
          end

          failure_message_for_should_not do |actual|
            "expected #{actual.inspect} to not all #{condition_string}"
          end

          description do
            "all be"
          end
        end
      end
    end

    # Handle mapping operators to appropriate collection mappers.
    class AllBeOperatorMatcher
      [:==, :!=, :>, :<, :<=, :>=, :=~].each do |op|
        define_method(op) do |value|
          AllBe.make_matcher("be #{op} #{value}") { |element|
            element.send(op, value)
          }
        end
      end
    end

    alias method_missing_without_all_be method_missing

    # Handle all_be_XXX predicates.  If it doesn't match the
    # all_be_XXX pattern, delegate to the existing method missing
    # handler.
    def method_missing(sym, *args, &block)
      if sym.to_s =~ /^all_be_(\w+)$/
        pred = $1
        pred_method = "#{pred}?"
        pred_string = AllBe.format_predicate(pred, *args)
        AllBe.make_matcher(pred_string) { |element|
          element.send(pred_method, *args, &block)
        }
      else
        method_missing_without_all_be(sym, *args, &block)
      end
    end

    # Return a matcher appropriate for matching across elements of a
    # collection.
    def all_be(matcher=nil, &block)
      if matcher
        AllBe.make_matcher("pass") { |element, messages|
          if matcher.matches?(element)
            true
          else
            messages << matcher.failure_message_for_should
            false
          end
        }
      elsif block_given?
        AllBe.make_matcher("satisfy the block", &block)
      else
        AllBeOperatorMatcher.new
      end
    end
  end
end
