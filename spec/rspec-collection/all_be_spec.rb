require 'spec_helper'
require 'rspec-collection/all_be'

class Integer
  def divisable_by?(n)
    (self % n) == 0
  end
end

describe "Collection Matchers" do

  # matcher ----------------------------------------------------------

  context "using matchers" do
    it "passing matcher" do
      [1,1,1].should all_be eq(1)
    end

    it "passing NOT matcher" do
      [1,2,1].should_not all_be eq(1)
    end

    it "failing matcher" do
      should_fail([1,2,3]) { |obj|
        obj.should all_be eq(1)
      }
    end

    it "failing NOT matcher" do
      should_fail([1,1,1]) { |obj|
        obj.should_not all_be eq(1)
      }
    end
  end

  # block ------------------------------------------------------------

  context "using blocks" do
    it "passing block" do
      [0,2,4].should all_be { |item| item.even? }
    end

    it "passing NOT block" do
      [0,2,5].should_not all_be { |item| item.even? }
    end

    it "failing NOT block" do
      should_fail([0,2,4]) { |obj|
        obj.should_not all_be { |item| item.even? }
      }
    end

    it "failing NOT block" do
      should_fail([0,2,4]) { |obj|
        obj.should_not all_be { |item| item.even? }
      }
    end
  end

  # predicates -------------------------------------------------------

  context "using predicates" do
    it "passing predicate" do
      [0,2,4].should all_be_even
    end

    it "passing NOT predicate" do
      [0,2,5].should_not all_be_even
    end

    it "failing predicate" do
      should_fail([0,2,5]) { |obj|
        obj.should all_be_even
      }
    end

    it "failing NOT predicate" do
      should_fail([0,2,4]) { |obj|
        obj.should_not all_be_even
      }
    end
  end

  # predicates with args ---------------------------------------------

  context "using predicates with arguments" do
    it "passing predicate" do
      [3,6,9].should all_be_divisable_by(3)
    end

    it "passing NOT predicate" do
      [3,6,8].should_not all_be_divisable_by(3)
    end

    it "failing predicate" do
      should_fail([3,6,8]) { |obj|
        obj.should all_be_divisable_by(3)
      }
    end

    it "failing NOT predicate" do
      should_fail([3,6,9]) { |obj|
        obj.should_not all_be_divisable_by(3)
      }
    end
  end

  # operator ---------------------------------------------------------

  context "using operators" do
    it "passing operator" do
      [1,1,1].should all_be == 1
    end

    it "passing NOT operator" do
      [1,1,2].should_not all_be == 1
    end

    it "failing operator" do
      should_fail([1,2,3]) { |obj|
        obj.should all_be < 3
      }
    end

    it "failing NOT operator" do
      should_fail([1,2,1]) { |obj|
        obj.should_not all_be < 3
      }
    end
  end

  private # ----------------------------------------------------------

  def should_fail(obj, &block)
    lambda {
      yield(obj)
    }.should raise_error(RSpec::Expectations::ExpectationNotMetError)
  end
end


describe "Error Messages" do

  # matcher ----------------------------------------------------------

  context "when matchers fail" do
    # it "contains multiple items" do
    #   lambda {
    #     [1,2,3].should all_be eq(1)
    #   }.should raise_error(
    #     RSpec::Expectations::ExpectationNotMetError,
    #     /xxx/m)
    # end
  end

  # predicate --------------------------------------------------------

  context "when predicates fail" do
    it "contains multiple items" do
      lambda {
        [1,0,3].should all_be_zero
      }.should raise_error(
        RSpec::Expectations::ExpectationNotMetError,
        /expected 1 to be zero.*expected 3 to be zero/m)
    end
  end

  context "when NOT predicates fail" do
    it "contains multiple items" do
      lambda {
        [0,0].should_not all_be_zero
      }.should raise_error(
        RSpec::Expectations::ExpectationNotMetError,
        /expected \[0, 0\] to not all be zero/m)
    end
  end



end
