require 'rails_helper'

describe Author do

  it { should have_many(:contributions).dependent(:destroy) }
  it { should have_many :posts }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should have_db_index :email }
  it { should validate_presence_of :name }

  it "has some kind of email validation" do
    author = Author.new(email: "unconvincingemail")
    expect(author).not_to be_valid
    expect(author.errors[:email]).to include('Your email is bad and you should feel bad')
  end
end
