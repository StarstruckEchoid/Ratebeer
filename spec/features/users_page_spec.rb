require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    @user = FactoryBot.create(:user, username: 'Pekka', password: 'Foobar1')
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "can delete their own ratings" do
      rating = make_rating(@user)
      sign_in(username: "Pekka", password: "Foobar1")
      visit user_path(@user)
      expect(page).to have_content('delete')
      expect{ click_link('delete', href: rating_path(rating)) }.to change{ Rating.where(user: @user).count }.by(-1)
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{ User.count }.by(1)
  end

  describe "homepage" do
    before :each do
      visit user_path(@user)
    end

    it "displays user's rating count" do
      expect(page).to have_content(/(0|no|any) ratings/)
    end

    it "doesn't display other people's ratings" do
      user2 = FactoryBot.create(:user, username: 'Mikko', password: 'Ch0sen0ne', password_confirmation: 'Ch0sen0ne')
      make_rating(user2)
      visit user_path(@user)
      expect(page).to have_content(/(0|no|any) ratings/)
    end

    describe "while user has made ratings" do
      before :each do
        @rating = make_rating(@user)
        visit user_path(@user)
      end

      it "displays user's ratings" do
        expect(page).to have_content('1 rating')
        expect(page).to have_content(@rating.beer)
        expect(page).to have_content(@rating.score)
      end

      it "displays favorite beer style" do
        expect(page).to have_content(@user.favorite_style)
      end

      it "displays favorite brewery" do
        expect(page).to have_content(@user.favorite_brewery.name)
      end
    end
  end
end

private

def make_rating(user)
  brewery = FactoryBot.create(:brewery)
  beer = FactoryBot.create(:beer, brewery: brewery)
  FactoryBot.create(:rating, beer: beer, user: user, score: 16)
end
