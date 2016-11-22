require 'spec_helper'

describe MoviesHelper do
    context ".oddness" do
        it "should return if a number is odd" do
            oddness(1).should eq "odd"
            oddness(2).should eq "even"
        end
    end
end