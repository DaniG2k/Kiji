class HomeController < ApplicationController
  helper_method :sort_column, :sort_direction
  def index
    articles = Article.order('val DESC')
    @first = articles.shift
    @second = articles.shift
    @third = articles.shift
    @articles =  Article.where.not(id: [@first.id, @second.id, @third.id])
                .order("#{sort_column} #{sort_direction}").paginate(page: params[:page])
  end
  
  private
  
  def sort_column
    %w(val title source).include?(params[:sort]) ? params[:sort] : 'val'
  end
  
  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'desc'
  end
end
