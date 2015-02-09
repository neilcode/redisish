require "spec_helper"

require_relative './model.rb'
require_relative './view.rb'
require_relative './controller.rb'
require_relative './simple_database.rb'

describe RedisishDatabase do
	before do
		@db = RedisishDatabase.new
	end

  describe "Storing Data" do
    it "has a #store method" do
      db.should respond_to(:store)
    end

    it "should be 0 for an empty array" do
      db.store.should == 0
    end

    it "should add all of the elements" do
      [1,2,4].sum.should == 7
    end
  end

  describe "GET" do 
    it "has a #retrieve_key method" do
      RedisishDatabase.should respond_to(:retrieve_key)
    end
  end

  describe 'square' do
    it "does nothing to an empty array" do
      [].square.should == []
    end

    it "returns a new array containing the squares of each element" do
      [1,2,3].square.should == [1,4,9]
    end
  end

  describe 'square!' do
    it "squares each element of the original array" do
      array = [1,2,3]
      array.square!
      array.should == [1,4,9]
    end
  end

end