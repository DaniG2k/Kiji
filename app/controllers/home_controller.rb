class HomeController < ApplicationController
  helper_method :sort_column, :sort_direction
  def index
    @articles = Article.order("#{sort_column} #{sort_direction}").paginate(page: params[:page])
  end
  
  private
  
  def sort_column
    %w(zscore title source).include?(params[:sort]) ? params[:sort] : 'zscore'
  end
  
  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'desc'
  end
end
