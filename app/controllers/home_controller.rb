class HomeController < ApplicationController
  helper_method :sort_column, :sort_direction
  def index
    @searched = params[:search].present? ? Article.search {fulltext params[:search]} : nil
        
    today_range = Time.zone.now.beginning_of_day.utc..Time.zone.now.end_of_day.utc
    yesterday_range = 1.day.ago.beginning_of_day.utc..1.day.ago.end_of_day.utc
    @today_articles = Article.where(:created_at => today_range)
    @yesterday_articles = Article.where(:created_at => yesterday_range)
    
    @today_articles = @today_articles.empty? ? @yesterday_articles : @today_articles
    
    #@top_three = @today_articles.order('val DESC').limit(3).to_a
    #@today_articles = @today_articles.where.not(id: [@top_three[0].id,
    #            @top_three[1].id, @top_three[2].id])
    #            .order("#{sort_column} #{sort_direction}")
    #            .paginate(page: params[:page], :per_page => 10)
    @today_articles = @today_articles.order("#{sort_column} #{sort_direction}")
                      .paginate(page: params[:page], :per_page => result_num)
  end
  
  def yesterday
    range = 1.day.ago.beginning_of_day.utc..1.day.ago.end_of_day.utc
    @yesterday_articles = get_articles_within(range)
  end
  
  def week
    range = 1.week.ago.beginning_of_day.utc..Time.zone.now.utc
    @week_articles = get_articles_within(range)
  end
  
  def month
    range = 1.month.ago.beginning_of_day.utc..Time.zone.now.utc
    @month_articles = get_articles_within(range)
  end
  
  def all
    @all_articles = Article.all.order('val DESC')
                .order("#{sort_column} #{sort_direction}")
                .paginate(page: params[:page], :per_page => result_num)
  end
  
  def about
  end
  
  private
  
  def result_num
    25
  end
  
  def sort_column
    %w(val title source).include?(params[:sort]) ? params[:sort] : 'val'
  end
  
  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'desc'
  end
  
  def get_articles_within(range)
    Article.where(:created_at => range)
    .order("#{sort_column} #{sort_direction}")
    .paginate(page: params[:page], :per_page => result_num)
  end
end
