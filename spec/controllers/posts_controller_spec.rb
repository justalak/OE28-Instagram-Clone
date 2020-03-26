require "rails_helper"

RSpec.describe PostsController, type: :controller do
  let!(:user){FactoryBot.create :user}
  let!(:posts){FactoryBot.create_list :post, 
    Settings.user.previews_per_page + 1,
    user_id: user.id}
  let!(:images){FilesTestHelper.upload}

  describe "GET #index" do
    before {get :index, xhr: true, params: {user_id: user.id}}
    
    it "assign @user" do
      expect(assigns :user).to eq user
    end
    
    it "assign @post" do
      expect(assigns :posts).to eq posts.reverse.slice(0,
        Settings.user.previews_per_page)
      end
      
    it "render template" do
      expect(response).to render_template(:index, format: :js)
    end
  end

  context "not login" do
    describe "POST #create" do
      before {post :create, params: {post: FactoryBot.attributes_for(:post)}}

      it "Not allow" do
        expect(response).to redirect_to(login_path)
      end

      it "flash redirect to login" do  
        expect(flash[:danger]).to match(I18n.t("login_first"))     
      end
    end

    describe "DELETE #destroy" do
      before {delete :destroy, params: {id: posts[0].id}}

      it "Not allow" do
        expect(response).to redirect_to(login_path)
      end

      it "flash redirect to login" do  
        expect(flash[:danger]).to match(I18n.t("login_first"))     
      end
    end

    describe "PATCH #update" do
      before {patch :update, params: {id: posts[0].id, post: FactoryBot.attributes_for(:post)}}

      it "Not allow" do
        expect(response).to redirect_to(login_path)
      end
      
      it "flash redirect to login" do  
        expect(flash[:danger]).to match(I18n.t("login_first"))     
      end
    end
  end
  
  context "User logged in" do
    before {log_in user}

    describe "POST #create" do
      before do 
        post :create, params: {post: {user_id: user.id, images: [images]}}
      end

      it "redirect to root path" do
        expect(response).to redirect_to(root_path)
      end

      it "flash success" do  
        expect(flash[:success]).to match(I18n.t(".posts.create.upload_successfully"))     
      end

      it "test number of posts" do
        expect{
          post :create, params: {post: {user_id: user.id, images: [images]}}
        }.to change(Post, :count).by(1)
      end
    end

    describe "GET #show" do
      before {get :show, params: {id: posts[0].id}}
      
      it "assign @post" do
        expect(assigns :post).to eq posts[0]
      end
      
      it "render template" do
        expect(response).to render_template(:show)
      end
  
      it "success status" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "DELETE #destroy" do
      let!(:p2) {FactoryBot.create :post, user_id: user.id}

      before {delete :destroy, params: {id: posts[0].id}}

      it "assign @post" do
        expect(assigns :post).to eq posts[0]
      end

      it "redirect status" do
        expect(response).to have_http_status(302)
      end

      it "flash success" do  
        expect(flash[:success]).to match(I18n.t(".posts.destroy.destroy_success"))     
      end

      it "test number of posts" do
        expect{
          delete :destroy, params: {id: p2.id}
        }.to change(Post, :count).by(-1)
      end
    end

    describe "PATCH #update" do
      before {patch :update, xhr: true, 
        params: {id: posts[0].id, post: {description: "New description"}}}

      it "assign @post" do
        expect(assigns :post).to eq posts[0]
      end

      it "flash success" do  
        expect(flash[:success]).to match(I18n.t(".posts.update.update_success"))     
      end

      it "render template" do
        expect(response).to render_template(:update, format: :js)
      end  
    end
  end
end
