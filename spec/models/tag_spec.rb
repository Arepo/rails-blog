require 'rails_helper'

describe Tag do

  it { should have_many :posts }
  it { should have_many :posts_tags }
end
