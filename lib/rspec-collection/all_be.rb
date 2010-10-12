# WARNING: Proof of Concept
#
# Allows:
#   [1,1,1].should all_be eq(1)
#   [2,4,6].should all_be_even
#   [2,3,5].should all_be { |n| prime?(n) }  # for appropriate definition of prime?#
#   [1,1,1].should all_be == 1
#   [3,6,9].should all_be_divisible_by(3)
#
module RSpec
  module Matchers
    module AllBe
      module_function

      def format_predicate(pred, *args)
        message_elements =
          ["be #{pred.gsub(/_/, ' ')}"] +
          args.map { |a| a.inspect }
        message_elements.join(' ')
      end

      def make_matcher(msg, &block)
        Matcher.new :all_be, block do |_block_|
          @failing_messages = []
          @broken = []
          match do |actual|
            actual.each do |item|
              unless _block_.call(item, @failing_messages)
                @broken << item
              end
            end
            @broken.empty?
          end

          failure_message_for_should do |actual|
            if @failing_messages.empty?
              messages = ["in #{actual.inspect}:"] +
                @broken.map { |item| "expected #{item.inspect} to #{msg}" }
            else
              messages = ["in #{actual.inspect}:"] + @failing_messages
            end
            messages.join("\n")
          end

          failure_message_for_should_not do |actual|
            "expected #{actual.inspect} to not all #{msg}"
          end

          description do
            "all be"
          end
        end
      end
    end

    class AllBeOperatorMatcher
      [:==, :!=, :>, :<, :<=, :>=].each do |op|
        define_method(op) do |value|
          AllBe.make_matcher("be #{op} #{value}") { |item|
            item.send(op, value)
          }
        end
      end
    end

    alias method_missing_without_all_be method_missing
    def method_missing(sym, *args, &block)
      if sym.to_s =~ /^all_be_(\w+)$/
        pred = $1
        pred_method = "#{pred}?"
        msg = AllBe.format_predicate(pred, *args)
        AllBe.make_matcher(msg) { |item|
          item.send(pred_method, *args, &block)
        }
      else
        method_missing_without_all_be(sym, *args, &block)
      end
    end

    def all_be(matcher=nil, &block)
      if matcher
        AllBe.make_matcher("pass") { |item, messages|
          if matcher.matches?(item)
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
