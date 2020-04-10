require "rails_helper"

RSpec.describe UsersController, type: :controller do 
  context "Not Login" do
    describe "GET #show" do
      before {get :show, params: {id: Settings.user.user_id1}}

      it "redirect to login page" do
        expect(response).to redirect_to(login_path)
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    describe "GET #new" do
      before do
        get :new
      end

      it "should redirect to login page" do
        expect(response).to render_template(:new)
      end

      it "should found" do
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST #create" do
      context "create user successfully" do
        let!(:user) {FactoryBot.create :user}

        before do
          post :create, params: {user: FactoryBot.attributes_for(:user)}
        end

        it "create user successfully" do  
          expect(response).to have_http_status(302)
        end

        it "flash create user successfully" do
          expect(flash[:success]).to match(I18n.t("users.create.signup_success"))  
        end

        it "test number of user" do
          expect{
            post :create, params: {user: FactoryBot.attributes_for(:user)}
          }.to change(User, :count).by(1)
        end
      end

      context "create user failed" do
        before do
          post :create, params: {user: {username: "!123", email: "@"}} 
        end

        it "create user failed" do
          expect(response).to render_template(:new)
        end

        it "flash now create user failed" do
          expect(flash.now[:danger]).to match(I18n.t("users.create.signup_failed"))
        end
      end
    end

    context "GET #edit" do
      before {get :edit, params: {id: Settings.user.user_id1}}

      it "redirect to login page" do
        expect(response).to redirect_to(login_path)
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    context "PATCH #update" do
      before {patch :update, params: {id: Settings.user.user_id1}}

      it "redirect to login page" do
        expect(response).to redirect_to(login_path)
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end
  end

  context "Logged in" do
    let!(:current_user){FactoryBot.create :user, id: Settings.user.user_id1}
    let!(:other_user){FactoryBot.create :user, id: Settings.user.user_id2}

    before do   
      log_in current_user
    end

    describe "GET #show" do
      context "show current user" do
        before do
          get :show, params: {id: current_user.id}
        end
  
        it "render show template" do
          expect(response).to render_template(:show)
        end
  
        it "should be success" do
          expect(response).to have_http_status(:ok)
        end
      end

      context "show other user" do
        before do
          get :show, params: {id: other_user.id}
        end
  
        it "render show template" do
          expect(response).to render_template(:show)
        end
  
        it "should be success" do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe "GET #edit" do
      context "correct user" do
        before do
          get :edit, params: {id: current_user.id}
        end
  
        it "render edit template" do
          expect(response).to render_template(:edit)
        end
  
        it "should be success" do
          expect(response).to have_http_status(:ok)
        end
      end

      context "incorrect user" do
        before do
          get :edit, params: {id: other_user.id}
        end
  
        it "redirect to root url" do
          expect(response).to redirect_to(root_path)
        end
  
        it "flash incorrect user" do
          expect(flash.now[:danger]).to match(I18n.t("users.correct_user.not_allow"))
        end
      end
    end

    describe "PATCH #update" do
      context "incorrect user" do
        before do
          patch :update,
          params: {
            id: other_user.id,
            user: FactoryBot.attributes_for(:user).merge(name: "user123")
          }
        end

        it "redirect to root url" do
          expect(response).to redirect_to(root_path)
        end

        it "flash incorrect user" do
          expect(flash.now[:danger]).to match(I18n.t("users.correct_user.not_allow"))
        end
      end

      context "correct user" do
        describe "update successfully" do
          before do
            patch :update,
            params: {
              id: current_user.id,
              user: FactoryBot.attributes_for(:user).merge(name: "khung long bo sua")
            }
          end
  
          it "redirect to @user" do
            expect(response).to redirect_to(current_user)
          end
    
          it "update success" do
            expect(flash[:success]).to match(I18n.t("users.update.update_succeed"))
            expect(current_user.reload.name).to eq("khung long bo sua")
          end

          it "should found" do
            expect(response).to have_http_status(302)
          end
        end
  
        describe "update failed" do
          before do
            User.find(current_user.id).update(name: "khung long bo sua")
            patch :update, params: {id: current_user.id, user: {name: ""}}
          end
  
          it "flash now update failed" do
            expect(flash.now[:danger]).to match(I18n.t("users.update.update_failed"))
          end

          it "update failed" do
            expect(User.find(current_user.id).name).to eq("khung long bo sua")
          end
        end
      end
    end
  end
end
