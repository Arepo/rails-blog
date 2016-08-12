require 'rails_helper'

describe Author do

  it { should have_many(:contributions).dependent(:destroy) }
  it { should have_many :posts }
  it { should validate_presence_of :email }
  it { should have_db_index :email }
  it { should validate_presence_of :name }
  it { should have_secure_password }

  it "has some kind of email validation" do
    author = Author.new(email: "unconvincingemail")
    expect(author).not_to be_valid
    expect(author.errors[:email]).to include('Your email is bad and you should feel bad')
  end

  it "auto-downcases emails before saving" do
    author = FactoryGirl.create(:author, email: "C@seby.Case")
    author.save
    expect(author.email).to eq "c@seby.case"
  end

  context "Validating uniqueness of email (twice)" do
    before { FactoryGirl.create :author, email: 'First-come@first-serv.edu' }

    it "validates at Rails level" do
      author = FactoryGirl.build(:author, email: "first-come@first-serv.edu")
      expect(author).not_to be_valid
    end

    it "validates at database level" do
      author = FactoryGirl.build(:author, email: "first-come@first-serv.edu")
      expect { author.save validate: false }.to raise_error ActiveRecord::RecordNotUnique
    end
  end
end
