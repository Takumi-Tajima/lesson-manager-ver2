module FormatDatetimeHelpers
  def format_datetime_for_input(time)
    "00#{time.strftime('%Y-%m-%d-%H:%M')}"
  end
end
