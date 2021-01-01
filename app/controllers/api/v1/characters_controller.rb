# frozen_string_literal: true

class Api::V1::CharactersController < ApplicationController
  skip_before_action :authorized, :only => [:index]

  # GET /characters
  def index
    @characters = Character.all

    render :json => @characters
  end
end
