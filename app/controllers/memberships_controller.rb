class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[show edit update destroy]
  before_action :ensure_that_signed_in, except: %i[show index]

  # GET /memberships or /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    # idk how this works dont ask
    @beer_clubs =
      BeerClub.all.where.not(
        memberships: Membership.where(user_id: current_user.id),
      )
    @membership = Membership.new
  end

  # GET /memberships/1/edit
  def edit
    @beer_clubs = BeerClub.all
  end

  # POST /memberships or /memberships.json
  def create
    @membership =
      Membership.new(params.require(:membership).permit(:beer_club_id))
    @membership.user = current_user

    respond_to do |format|
      if @membership.save
        format.html do
          redirect_to user_path(current_user),
                      notice: "successfully joined club"
        end
        format.json { render :show, status: :created, location: @membership }
      else
        @beer_clubs = BeerClub.all
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @membership.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html do
          redirect_to membership_url(@membership),
                      notice: "Membership was successfully updated."
        end
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @membership.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    @membership.destroy

    respond_to do |format|
      format.html do
        redirect_to memberships_url,
                    notice: "Membership was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def membership_params
    params.require(:membership).permit(:user_id, :beer_club_id)
  end
end
