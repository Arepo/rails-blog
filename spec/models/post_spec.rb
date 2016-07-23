require 'rails_helper'

describe Post do

  it { should have_many :tags }
  it { should have_many :contributions }
  it { should have_many :authors }
  it { should have_many :posts_tags }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

end
