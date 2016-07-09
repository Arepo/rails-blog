require 'rails_helper'

describe Post do

  it { should have_many :tags }
  it { should have_many :contributions }
  it { should have_many :authors }
  it { should have_many :posts_tags }
end
