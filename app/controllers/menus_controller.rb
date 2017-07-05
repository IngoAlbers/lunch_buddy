class MenusController < ActionController::Base
  def lilly_jo
    require 'open-uri'

    week = params[:week] || current_week
    io = open("https://lillyjo.ch/wp-content/uploads/2015/09/lilly-jo_wochenmenue_kw-#{week}.pdf")
    reader = PDF::Reader.new(io)

    str = []

    reader.objects.values.each do |v|
      str << v[:ActualText] if v.class == Hash
    end

    @str = str.join(' ')
  end

  private

  def current_week
    Time.now.strftime('%W')
  end
end
