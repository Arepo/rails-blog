require 'rails_helper'

describe Author do

  it { should have_many(:contributions).dependent(:destroy) }
  it { should have_many :posts }
  it { should validate_presence_of :password }
  it { should validate_presence_of :email }
  it { should validate_presence_of :name }
end
