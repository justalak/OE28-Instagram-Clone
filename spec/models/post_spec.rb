require "rails_helper"

RSpec.describe Post, type: :model do
  let!(:user){FactoryBot.create :user}
  let!(:u1){FactoryBot.create :user}
  let!(:u2){FactoryBot.create :user}

  let!(:p1){FactoryBot.create :post, user_id: u2.id, description: "aa"}
  let!(:p2){FactoryBot.create :post, user_id: u1.id, description: "zz"}

  subject {FactoryBot.build :post, user_id: user.id}

  describe "Create" do
    it {is_expected.to be_valid}
  end

  describe "Association" do
    it {is_expected.to belong_to :user}
    it {is_expected.to have_many(:comments).dependent :destroy}
    it {is_expected.to have_many(:bookmark_likes).dependent :destroy}
    it {is_expected.to have_many :hashtags}
  end

  describe "Delegate" do
    it {should delegate_method(:name).to(:user).with_prefix(:user)}
    it {should delegate_method(:username).to(:user).with_prefix(:user)}
  end

  describe "Validations" do
    it {is_expected.to validate_presence_of(:user_id)}
    it {expect(subject.images).to be_attached}
  end

  describe "Callback" do 
    it { is_expected.to callback(:add_hashtags).after(:commit)}
  end

  describe "Scope" do
    let!(:u3){FactoryBot.create :user, username: "viethoang"}

    let!(:p3){FactoryBot.create :post, user_id: u1.id, description: "ab"}
    let!(:p4){FactoryBot.create :post, :with_hashtags, user_id: u3.id}
    let!(:p5){FactoryBot.create :post, :with_hashtags, user_id: u3.id}
    
    let!(:rel1){FactoryBot.create :relationship, follower_id: u1.id,
      followed_id: u2.id}
    let!(:bookmark){FactoryBot.create :bookmark_like, :bookmark, :for_post, 
      user_id: u1.id, likeable_id: p1.id}
    
    context "Order by created at" do
      it {expect(Post.order_by_created_at).to eq [p5, p4, p3, p2, p1]}
    end

    context "Order by description " do
      it {expect(Post.order_by_description).to eq [p4, p5, p1, p3, p2]}
    end

    context "Bookmarking by user" do
      it {expect(Post.bookmarking_by_user u1.id).to eq [p1]}
    end

    context "Feed" do
      it {expect(Post.feed u1).to eq [p1,p2,p3]}
    end

    context "Search by hashtags" do
      it {expect(Post.search_by_hashtag "rspec").to eq [p4, p5]}
    end

    context "Search by description or username" do
      it {expect(Post.search_by_description_username "ab").to eq [p3]}
      it {expect(Post.search_by_description_username "viethoang").to eq [p4,p5]}
    end
  end

  describe "Method" do
    let!(:l1) {FactoryBot.create(:bookmark_like, :like, :for_post, 
      user_id: u1.id, likeable_id: p2.id)}
    let!(:l2) {FactoryBot.create(:bookmark_like, :like, :for_post, 
      user_id: u2.id, likeable_id: p1.id)}

    let!(:c1) {FactoryBot.create(:comment, post_id: p1.id)}
    let!(:c2) {FactoryBot.create(:comment, post_id: p1.id)}
    let!(:c3) {FactoryBot.create(:comment, post_id: p1.id)}

    context ".likers" do
      it {expect(p2.likers? u1).to eq true}
      it {expect(p2.likers? u2).to eq false}
    end

    context ".top_comments" do
      it {expect(p1.top_comments).to eq [c2, c3]}
    end
  end 
end
