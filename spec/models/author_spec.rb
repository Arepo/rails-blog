require 'rails_helper'

describe Author do

  it { should have_many(:contributions).dependent(:destroy) }
  it { should have_many :posts }
  it { should validate_presence_of :email }
  it { should have_db_index :email }
  it { should validate_presence_of :name }
  it { should have_secure_password }

  let(:author) { FactoryGirl.build :author }

  it "has some kind of email validation" do
    author.email = "unconvincingemail"
    expect(author).not_to be_valid
    expect(author.errors[:email]).to include('Your email is bad and you should feel bad')
  end

  it "auto-downcases emails before saving" do
    author.update(email: "C@seby.Case")
    author.save
    expect(author.email).to eq "c@seby.case"
  end

  context "Validating uniqueness of email (twice)" do
    before { FactoryGirl.create :author, email: 'First-come@first-serv.edu' }

    it "validates at Rails level" do
      author.email = "first-come@first-serv.edu"
      expect(author).not_to be_valid
    end

    it "validates at database level" do
      author.email = "first-come@first-serv.edu"
      expect { author.save validate: false }.to raise_error ActiveRecord::RecordNotUnique
    end
  end

  context "Authentication" do
    it "Stores a digested token to remember users by" do
      author.remember
      expect(author.reload.remember_digest).to start_with '$2a$'
    end

    it "Deletes the token when forgetting the user" do
      author.remember
      author.forget
      expect(author.reload.remember_digest).to be nil
    end

    it "Can check whether a token matches its (hashed) own" do
      allow(SecureRandom).to receive(:urlsafe_base64).and_return "LptYPGADzd97e3Bd1c-n8g"
      author.remember
      expect(author.authenticated? 'LptYPGADzd97e3Bd1c-n8g').to be true
    end
  end
end
