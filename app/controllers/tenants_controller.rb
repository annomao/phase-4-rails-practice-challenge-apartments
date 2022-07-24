class TenantsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_record

  def index
    render json: Tenant.all, status: :ok
  end

  def show
    tenant = get_tenant
    render json: tenant
  end

  def create
    tenant = Tenant.create!(allowed_params)
    render json: tenant, status: :created
  end

  def update
    tenant = get_tenant
    tenant.update!(allowed_params)
    render json: tenant
  end

  def destroy
    tenant = get_tenant
    tenant.destroy
    render :no_content
  end

  private

  def get_tenant
    Tenant.find(params[:id])
  end

  def record_not_found
    render json: {errors: "Record not found"}
  end

  def allowed_params
    params.permit(:name, :age)
  end

  def unprocessable_entity_record(e)
    render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
  end
end
