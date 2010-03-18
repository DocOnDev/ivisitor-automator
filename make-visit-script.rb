require 'lib/emit_seleneese.rb'

if $0 == __FILE__
  unless ARGV[0]
    puts "You must provide the visit date"
  end
  visit_date = ARGV[0]
  visiting = ARGV[1]
  event = ARGV[2]
  start_time = ARGV[3]
  end_time = ARGV[4]
  input_file = ARGV[5]

  emitter = EmitSeleneese.new(visit_date, visiting, event, start_time, end_time, input_file)
  emitter.emit
  visit_date, visiting='Norton, Michael', company='Chi Ruby',
        start_time='6:00 PM', end_time='9:00 PM', input='resource/rsvps.txt'
end