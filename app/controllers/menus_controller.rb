class MenusController < ActionController::Base
  def lilly_jo
    require 'open-uri'

    date = get_date
    week = date.strftime('%W')

    io = open("https://lillyjo.ch/wp-content/uploads/2015/09/lilly-jo_wochenmenue_kw-#{week}.pdf")
    reader = PDF::Reader.new(io)

    str = []

    reader.objects.values.each do |v|
      str << v[:ActualText] if v.class == Hash
    end

    @str = get_content(sanitize(str.join(' ')), date)
  rescue StandardError
    @str = 'Oops! Something went wrong. Please contact the botmaster.'
  ensure
    post_message(@str, date)
  end

  private

  def get_date
    if params[:date]
      Date.parse(params[:date])
    else
      Date.today
    end
  end

  def get_content(str, day)
    day_start = formatted_day(day)
    day_end = formatted_day(day + 1.day)

    if day_start == 'Freitag'
      str[/#{day_start}(.*)/, 1]
    else
      str[/#{day_start}(.*?)#{day_end}/, 1]
    end
  end

  def sanitize(str)
    str.force_encoding("ASCII-8BIT")
       .gsub(/#{"\x00|\xFE|\xFF".force_encoding("ASCII-8BIT")}/, '')
       .gsub(/#{"\xE4".force_encoding("ASCII-8BIT")}/, 'ae')
       .gsub(/#{"\xF6".force_encoding("ASCII-8BIT")}/, 'oe')
       .gsub(/#{"\xFC".force_encoding("ASCII-8BIT")}/, 'ue')
       .gsub(/#{"\xE9".force_encoding("ASCII-8BIT")}/, 'e')
  end

  def formatted_day(date)
    I18n.l(date, format: '%A', locale: :de)
  end

  def post_message(message, date)
    return if message.nil?

    text = "*Heute (#{l(date)}) im Lilly Jo:*\n"
    text << message

    client = SlackBot.new
    client.chat_postMessage(channel: '#lunchtime', text: text)
  end
end
