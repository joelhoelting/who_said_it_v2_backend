class Api::V1::QuotesController < ApplicationController
  before_action :set_quote, :only => [:show, :update, :destroy]
  skip_before_action :authorized, :only => [:index, :show]

  # GET /quotes
  def index
    @quotes = Quote.all

    render :json => @quotes
  end

  # GET /quotes/1
  def show
    render :json => @quote
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def quote_params
      params.fetch(:quote, {})
    end
end
