class GrantsController < ApplicationController
  # before_action :set_grant, only: [:show, :edit, :update, :destroy]

  # GET /grants
  # GET /grants.json
  # def index
  #   @grants = Grant.all
  # end

  # GET /grants/1
  # GET /grants/1.json
  # def show
  # end

  # GET /grants/new
  def new
    # raise params
    @grant = Grant.new(project_id: params[:project_id], resource_id: params[:resource_id])
  end

  # GET /grants/1/edit
  # def edit
  # end

  # POST /grants
  # POST /grants.json
  def create
    @grant = Grant.new(grant_params)

    respond_to do |format|
      if @grant.save
        format.html { redirect_to project_path(@grant.project_id), notice: 'Grant was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /grants/1
  # PATCH/PUT /grants/1.json
  # def update
  #   respond_to do |format|
  #     if @grant.update(grant_params)
  #       format.html { redirect_to @grant, notice: 'Grant was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @grant }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @grant.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /grants/1
  # DELETE /grants/1.json
  # def destroy
  #   @grant.destroy
  #   respond_to do |format|
  #     format.html { redirect_to grants_url, notice: 'Grant was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_grant
    #   @grant = Grant.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grant_params
      params.require(:grant).permit(:project_id, :resource_id)
    end
end
