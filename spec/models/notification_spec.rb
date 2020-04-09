require "rails_helper"

RSpec.describe Notification, type: :model do
  let!(:u1){FactoryBot.create :user}
  let!(:u2){FactoryBot.create :user}
  let!(:p1){FactoryBot.create :post}
  subject {FactoryBot.build :notification, sender_id: u1.id,
    receiver_id: u2.id,
    post_id: p1.id}
  
  describe "Association" do
    it {is_expected.to belong_to(:sender).class_name(User.name)}
    it {is_expected.to belong_to(:receiver).class_name(User.name)}
    it {is_expected.to belong_to(:post).optional(true)}    
  end

  describe "Validate" do
    it {is_expected.to validate_presence_of(:sender_id)}
    it {is_expected.to validate_presence_of(:receiver_id)}    
  end

  describe "Delegate" do
    it {should delegate_method(:username).to(:sender).with_prefix(:sender)}
  end

  describe "Enum" do
    it { is_expected.to define_enum_for(:type_notif).with_values([:follow, :like,
      :comment, :reply, :like_comment, :mention, :request, :accept])}
    it { is_expected.to define_enum_for(:status).with_values([:unread, :read])}
  end

  describe "Scope" do
    let!(:n0) {FactoryBot.create :notification, sender_id: u1.id, 
      receiver_id: u2.id, type_notif: Settings.notification.follow}
    let!(:n1) {FactoryBot.create :notification, sender_id: u1.id, 
      receiver_id: u2.id, type_notif: Settings.notification.like}
    let!(:n2) {FactoryBot.create :notification, sender_id: u1.id, 
      receiver_id: u2.id, type_notif: Settings.notification.comment}
    let!(:n3) {FactoryBot.create :notification, sender_id: u1.id, 
      receiver_id: u2.id, type_notif: Settings.notification.reply}
    let!(:n4) {FactoryBot.create :notification, sender_id: u2.id, 
      receiver_id: u1.id, type_notif: Settings.notification.like_comment}
    let!(:n5) {FactoryBot.create :notification, sender_id: u2.id, 
      receiver_id: u1.id, type_notif: Settings.notification.mention}
    let!(:n6) {FactoryBot.create :notification, sender_id: u2.id, 
      receiver_id: u1.id, type_notif: Settings.notification.request}
    let!(:n7) {FactoryBot.create :notification, sender_id: u2.id, 
      receiver_id: u1.id, type_notif: Settings.notification.accept}
    
    context "Order by created at" do
      it {expect(Notification.order_by_created_at).to eq [n7, n6, n5, n4, n3,
        n2, n1, n0]}
    end

    context "Get by all" do
      it {expect(Notification.get_by_all(u1.id, u2.id, 
        Settings.notification.follow)).to eq [n0]}
    end

    context "about_post" do
      it {expect(Notification.about_post).to eq [n1, n2, n3, n4, n5]}
    end

    context "Follow and request" do
      it {expect(Notification.follow_request).to eq [n0, n6, n7]}
    end
  end
end
