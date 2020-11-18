module ApplicationHelper
  def fix_url(str)
    str.start_with?('http://') || str.start_with?('https://') ? str : 'http://' + str
  end

  def display_datetime(dt)
    dt.strftime("%m/%d/%Y %l:%M%P %Z")
  end
end
