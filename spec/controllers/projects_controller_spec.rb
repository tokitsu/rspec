require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  describe "#index" do
    context "as an authenticated user" do

      before do
        @user = FactoryBot.create(:user)
      end

      it "responds successfully" do
        sign_in @user
        get :index
        expect(response).to be_success
      end

      it "return a 200 response" do
        sign_in @user
        get :index
        expect(response).to have_http_status "200"
      end
    end

    context "as a guest" do

      it "returns  a 302 response" do
        get :index
        expect(response).to have_http_status "302"
      end


      it "redirects to the sign-in page" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#show" do
    context "as an authorized user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "responds successfully" do
        sign_in @user
        get :show, params: {id: @project.id}
        expect(response).to be_success
      end
    end

    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it "redirects to the dashboard" do
        sign_in @user
        get :show, params: {id: @project.id}
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#create" do
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end

      it "adds a project" do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        expect {
          post :create, params: {project: project_params}
        }.to change(@user.projects, :count).by(1)
      end
    end

    context "as a guest" do

      it "returns a 302 response" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params:{project: project_params}
        expect(response).to have_http_status "302"
      end

      it "redirects to the sign-in page" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params}
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#update" do
    context "as an authorized user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "updates a project" do
        project_params = FactoryBot.attributes_for(:project,name: "new project name")
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params}
        expect(@project.reload.name).to eq "new project name"
      end
    end

    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user,
        name: "same old name")
      end

      it "does not update the project" do
        project_params = FactoryBot.attributes_for(:project,
        name: "new name")
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params}
        expect(@project.reload.name).to eq "same old name"
      end

      it "redirects to the dashboard" do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        patch :update, params: {id: @project.id, project: project_params }
        expect(response).to redirect_to root_path
      end
    end

    context "as a guest" do
      before do
        @project = FactoryBot.create(:project)
      end

      it "return a 302 response" do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params
        }
        expect(response).to have_http_status "302"
      end

      it "redirects to the sign_in page" do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: {id: @project.id, project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end

  end
end