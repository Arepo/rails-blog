require 'rails_helper'

describe Author do

  it { should have_many(:contributions).dependent(:destroy) }
  it { should have_many :posts }
  it { should validate_presence_of :email }
  it { should have_db_index :email }
  it { should validate_presence_of :name }
  it { should have_secure_password }

  let(:author) { FactoryGirl.build :author }

  context "scoping" do
    let!(:author2) { FactoryGirl.create :author }

    it "finds all but one author" do
      author.save
      expect(Author.other_than(author).to_a).to eq [author2]
      expect(Author.other_than(author2).to_a).to eq [author]
    end
  end

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

  context "public methods" do
    context '#to_s' do
      it "Returns the author's name" do
        expect(author.to_s).to eq author.name
      end
    end

    context "Authentication" do
      context '#remember' do
        it 'stores a digested token to remember users by' do
          author.remember
          expect(author.reload.remember_digest).to start_with '$2a$' #Standard BCrypt prefix
        end
      end

      context '#forget' do
        it 'deletes the remember_digest' do
          author.remember
          author.forget
          expect(author.reload.remember_digest).to be nil
        end
      end

      context '#authenticate' do
        it "checks an author's remember_digest against passed in token" do
          allow(SecureRandom).to receive(:urlsafe_base64).and_return "LptYPGADzd97e3Bd1c-n8g"
          author.remember
          expect(author.authenticated? 'LptYPGADzd97e3Bd1c-n8g').to be true
        end

        it "Automatically returns false if the author has no remember_digest" do
          expect(author.authenticated? 'Irrelevant token').to be false
        end
      end
    end
  end
end
