class Api::V1::QuotesController < ApplicationController
  skip_before_action :authorized
  
  def index
    @quotes = Quote.all
    render :json => @quotes
  end

  def show
    @quote = Quote.find(params[:id])
    render :json => @quote
  end
end
