class LeasesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_record

  def create
    lease = Lease.create!(allowed_params)
    render json: lease, status: :created
  end

  def destroy
    lease = get_lease
    lease.destroy
    render :no_content
  end

  private

  def get_lease
    Lease.find(params[:id])
  end

  def record_not_found
    render json: {errors: "Record not found"}
  end

  def allowed_params
    params.permit(:rent, :apartment_id, :tenant_id)
  end

  def unprocessable_entity_record
    render json: {errors: "Unable to perform request"}, status: :unprocessable_entity
  end
end
