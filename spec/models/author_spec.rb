require 'rails_helper'

describe Author do

  it { should have_many :posts }

end
