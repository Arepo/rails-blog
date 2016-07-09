require 'rails_helper'

describe Post do

  it { should have_many :contributions }
  it { should have_many :authors }
end
