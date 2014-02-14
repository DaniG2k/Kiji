module ApplicationHelper
  def title(*parts)
    content_for(:title) { (parts << 'Kiji').join(' - ') } unless parts.empty?
  end
  
  def sortable(column, title=nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, {:sort => column, :direction => direction}
  end
  
  def footer_date
    Time.now.year == 2014 ? "2014" : "2014-#{Time.now.year}"
  end
end
