require 'rails_helper'

describe TweetsController, type: :controller do

  describe 'GET #edit' do
    it "assigns the requested contact to @tweet" do
      tweet = create(:tweet)
    end

    it "renders the :edit template" do
    end
  end
end
