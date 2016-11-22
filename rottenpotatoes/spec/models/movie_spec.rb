require 'spec_helper'

describe Movie, :type => :model do
  it "is valid with valid attributes" do
    expect(Movie.new).to be_valid
  end
  it "is valid without a director" do
      movie = Movie.new(director: nil)
    expect(movie).to be_valid
  end
  it "has ratings: G PG PG-13 NC-17 R" do
      expect(Movie.all_ratings).to eq ["G", "PG", "PG-13", "NC-17", "R"]
  end
end