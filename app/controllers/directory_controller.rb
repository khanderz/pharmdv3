# frozen_string_literal: true

class DirectoryController < ApplicationController
  def directory
    @directory_props = { greeting: 'Welcome to the Directory!' }

    render 'directory/directory'
  end
end
