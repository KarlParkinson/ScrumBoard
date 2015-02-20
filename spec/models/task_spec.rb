require 'rails_helper'

describe Task do

  it "has a valid factory" do
    expect(create(:task)).to be_valid
  end

  it "is invalid without a body" do
    expect(build(:task, body: nil)).to_not be_valid
  end

  it "is invalid without a status" do
    expect(build(:task, status: nil)).to_not be_valid
  end

  it "is invalid with a status that is not in ['todo', 'doing', 'done']" do
    expect(build(:task, status: 'blah')).to_not be_valid
  end

end
