# WARNING: Unrefactored Proof of Concept
#
# Allows:
#   [1,1,1].should all_be eq(1)
#   [2,4,6].should all_be_even
#   [2,3,5].should all_be { |n| prime?(n) }  # for appropriate definition of prime?#
#
# Not Yet Implemented:
#   [1,1,1].should all_be == 1
#   [3,6,9].should all_be_divisible_by(3)
#
module RSpec
  module Matchers
    class AllBeOperatorMatcher
      [:==, :!=, :>, :<, :<=, :>=].each do |op|
        define_method(op) do |value|
          make_op_matcher(op, value)
        end
      end

      def make_op_matcher(op, value)
        Matcher.new :all_be, op, value do |_op_, _value_|
          result = true
          match do |actual|
            actual.each do |item|
              unless item.send(op, value)
                @broken_item = item
                result = false
                break
              end
            end
            result
          end

          failure_message_for_should do |actual|
            "in #{actual.inspect}:\n" +
              "expected #{@broken_item.inspect} to be #{op} #{value}"
          end

          failure_message_for_should_not do |actual|
            "in #{actual.inspect}:\n" +
              "expected #{@broken_item.inspect} to not be #{op} #{value}"
          end

          description do
            "be all"
          end
        end
      end
    end

    alias method_missing_without_be_all method_missing
    def method_missing(sym, *args, &block)
      if sym.to_s =~ /^all_be_(\w+)$/
        _all_be_with_predicate($1, *args, &block)
      else
        method_missing_without_be_all(sym, *args, &block)
      end
    end

    def all_be(matcher=nil, &block)
      if matcher
        _all_be_with_matcher(matcher)
      elsif block_given?
        _all_be_with_block(block)
      else
        AllBeOperatorMatcher.new
      end
    end

    def _all_be_with_block(block)
      Matcher.new :all_be, block do |_block_|
        result = true
        match do |actual|
          actual.each do |item|
            unless _block_.call(item)
              @broken_item = item
              result = false
              break
            end
          end
          result
        end

        failure_message_for_should do |actual|
          "in #{actual.inspect}:\n" +
            "expected #{@broken_item.inspect} to satisfy block"
        end

        failure_message_for_should_not do |actual|
          "in #{actual.inspect}:\n" +
            "expected #{@broken_item.inspect} to not satisfy block"
        end

        description do
          "be all"
        end
      end
    end

    def _all_be_with_predicate(pred, *args, &block)
      Matcher.new :all_be, pred do |_pred_|
        pred_method = "#{pred}?"
        result = true
        match do |actual|
          actual.each do |item|
            unless item.send(pred_method, *args, &block)
              @broken_item = item
              result = false
              break
            end
          end
          result
        end

        failure_message_for_should do |actual|
          "in #{actual.inspect}:\n" +
            "expected #{@broken_item.inspect} to be #{pred}"
        end

        failure_message_for_should_not do |actual|
          "in #{actual.inspect}:\n" +
            "expected #{@broken_item.inspect} to not be #{pred}"
        end

        description do
          "be all #{pred}"
        end
      end
    end

    def _all_be_with_matcher(matcher)
      Matcher.new :all_be, matcher do |_matcher_|
        result = true
        match do |actual|
          actual.each do |item|
            unless _matcher_.matches?(item)
              result = false
              break
            end
          end
          result
        end

        failure_message_for_should do |actual|
          "in #{actual.inspect}:\n" +
            _matcher_.failure_message_for_should
        end

        failure_message_for_should_not do |actual|
          "in #{actual.inspect}:\n" +
            _matcher_.failure_message_for_should_not
        end

        description do
          "be all #{_matcher_.description}"
        end
      end
    end
  end
end
