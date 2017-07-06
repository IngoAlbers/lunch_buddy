class MenusController < ActionController::Base
  def lilly_jo
    require 'open-uri'

    date = get_date
    week = date.strftime('%W')

    io = open("https://lillyjo.ch/wp-content/uploads/2015/09/lilly-jo_wochenmenue_kw-#{week}.pdf")
    reader = PDF::Reader.new(io)

    text = "*Heute (#{l(date)}) im Lilly Jo:*\n"
    text << get_daily_menu(reader, date)

    post_message(text, '#lunchtime')
  rescue StandardError
    post_message('Oops! Something went wrong. Please contact the botmaster.', '#lunchtime')
  end

  private

  def get_date
    if params[:date]
      Date.parse(params[:date])
    else
      Date.today
    end
  end

  def get_daily_menu(reader, date)
    actual_text = get_actual_text(reader)
    get_content(actual_text, date)
  end

  def get_actual_text(reader)
    str = reader.objects.values.select { |v| v.class == Hash }.map { |v| v[:ActualText] }
    sanitize(str.join())
  end

  def get_content(str, date)
    date_start = formatted_date(date)
    date_end = formatted_date(date + 1.day)

    if date_start == 'Freitag'
      str[/#{date_start}(.*)/, 1]
    else
      str[/#{date_start}(.*?)#{date_end}/, 1]
    end
  end

  def sanitize(str)
    str = str.force_encoding("ASCII-8BIT")
             .gsub(/#{"\x00|\xFE|\xFF".force_encoding("ASCII-8BIT")}/, '')
             .gsub(/#{"\xE4".force_encoding("ASCII-8BIT")}/, 'ae')
             .gsub(/#{"\xF6".force_encoding("ASCII-8BIT")}/, 'oe')
             .gsub(/#{"\xFC".force_encoding("ASCII-8BIT")}/, 'ue')
             .gsub(/#{"\xE9".force_encoding("ASCII-8BIT")}/, 'e')

    str.gsub('ae', 'ä')
       .gsub('oe', 'ö')
       .gsub('ue', 'ü')
  end

  def formatted_date(date)
    I18n.l(date, format: '%A', locale: :de)
  end

  def post_message(message, channel)
    client = SlackBot.new
    client.chat_postMessage(channel: channel, text: message, as_user: true)
  end
end

