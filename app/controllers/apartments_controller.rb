class ApartmentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_record

  def index
    render json: Apartment.all, status: :ok
  end

  def show
    apartment = get_apartment
    render json: apartment
  end

  def create
    apartment = Apartment.create!(allowed_params)
    render json: apartment, status: :created
  end

  def update
    apartment = get_apartment
    apartment.update(allowed_params)
    render json: apartment
  end

  def destroy
    apartment = get_apartment
    apartment.destroy
    render :no_content
  end

  private

  def get_apartment
    Apartment.find(params[:id])
  end

  def record_not_found
    render json: {errors: "Record not found"}
  end

  def allowed_params
    params.permit(:number)
  end

  def unprocessable_entity_record
    render json: {errors: "Unable to perform request"}, status: :unprocessable_entity
  end
end
