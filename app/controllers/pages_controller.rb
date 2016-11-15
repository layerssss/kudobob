class PagesController < ApplicationController
  def home
    @dojos = Dojo.first(5)
  end
end
