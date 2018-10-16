class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy, :confirm]
  before_action :ensure_that_member_too, only: [:confirm]
  before_action :set_beer_clubs, only: [:new, :create]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(membership_params)

    @membership.user = current_user

    respond_to do |format|
      if @membership.save
        format.html { redirect_to @membership.beer_club, notice: "Welcome to the club, #{@membership.user.username}!" }
        format.json { render :show, status: :created, location: @membership }
      else
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership.destroy
    raise "Membership not destroyed" if Membership.all.include? @membership

    respond_to do |format|
      format.html { redirect_to @membership.user, notice: "You succesfully left #{@membership.beer_club.name}." }
      format.json { head :no_content }
    end
  end

  def confirm
    if @membership&.update confirmed: true
      redirect_to request.referrer, notice: "#{@membership.user} was accepted into #{@membership.beer_club}."
    else
      byebug
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  def set_beer_clubs
    u = User.find_by id: current_user
    @beer_clubs = BeerClub.all.reject { |bc| bc.members.include? u }
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def membership_params
    params.require(:membership).permit(:user_id, :beer_club_id)
  end

  def ensure_that_member_too
    redirect_to request.referrer, notice: "You have to be a member of this club to confirm new members." unless @membership.beer_club.confirmed_member? current_user
  end
end
