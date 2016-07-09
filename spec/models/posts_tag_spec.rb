require 'rails_helper'

describe PostsTag do

  it { should belong_to :tag }
  it { should belong_to :post }
end
