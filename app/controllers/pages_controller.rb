class PagesController < ApplicationController
  def home
  end

  def about
    @info = {who_made_it: "nathan@bitcubeintern.com",
             what_it_do: "This program calculates basic antiderivatives.",
             when_it_made: "July 31st 2023"
    }
  end
end
