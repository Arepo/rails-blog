require 'rails_helper'

describe Contribution do

  it { should belong_to :post }
  it { should belong_to :author }
end
