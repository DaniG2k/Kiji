class HomeController < ApplicationController
  helper_method :sort_column, :sort_direction
  def index
    today_range = Time.zone.now.beginning_of_day.utc..Time.zone.now.end_of_day.utc
    yesterday_range = 1.day.ago.beginning_of_day.utc..1.day.ago.end_of_day.utc
    
    @today_articles = Article.where(:created_at => today_range)
    @yesterday_articles = Article.where(:created_at => yesterday_range).order('val DESC')
    
    @today_articles = @yesterday_articles if @today_articles.empty?

    top_three = @today_articles.order('val DESC')
    @first = top_three.shift
    @second = top_three.shift
    @third = top_three.shift
    
    @today_articles = @today_articles.where.not(id: [@first.id, @second.id, @third.id])
                .order("#{sort_column} #{sort_direction}")
                .paginate(page: params[:page], :per_page => 10)
  end
  
  def yesterday
    yesterday_range = 1.day.ago.beginning_of_day.utc..1.day.ago.end_of_day.utc
    @yesterday_articles = Article.where(:created_at => yesterday_range).order('val DESC')
                .order("#{sort_column} #{sort_direction}")
                .paginate(page: params[:page], :per_page => 10)
  end
  
  private
  
  def sort_column
    %w(val title source).include?(params[:sort]) ? params[:sort] : 'val'
  end
  
  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'desc'
  end
end
