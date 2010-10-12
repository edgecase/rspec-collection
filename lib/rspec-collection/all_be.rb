# WARNING: Unrefactored Proof of Concept
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
            "be all"
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
        AllBe.make_matcher("pass") { |item, messages|
          if matcher.matches?(item)
            true
          else
            messages << matcher.failure_message_for_should
            false
          end
        }
      elsif block_given?
        AllBe.make_matcher("satisfy block", &block)
      else
        AllBeOperatorMatcher.new
      end
    end

    def _all_be_with_predicate(pred, *args, &block)
      pred_method = "#{pred}?"
      AllBe.make_matcher("be #{pred}") { |item|
        item.send(pred_method, *args, &block)
      }
    end

    def _all_be_with_matcher(matcher)
      # Matcher.new :all_be, matcher do |_matcher_|
      #   result = true
      #   match do |actual|
      #     actual.each do |item|
      #       unless _matcher_.matches?(item)
      #         result = false
      #         break
      #       end
      #     end
      #     result
      #   end

      #   failure_message_for_should do |actual|
      #     "in #{actual.inspect}:\n" +
      #       _matcher_.failure_message_for_should
      #   end

      #   failure_message_for_should_not do |actual|
      #     "in #{actual.inspect}:\n" +
      #       _matcher_.failure_message_for_should_not
      #   end

      #   description do
      #     "be all #{_matcher_.description}"
      #   end
      # end
    end
  end
end
