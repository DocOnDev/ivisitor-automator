class EmitSeleneese
  def initialize(visit_date, visiting='Norton, Michael', event='Chi Ruby',
          start_time='6:00 PM', end_time='9:00 PM', input='resource/rsvps.txt')

    visiting ||= 'Norton, Michael'
    event ||='Chi Ruby'
    start_time ||='6:00 PM'
    end_time ||='9:00 PM'
    input ||='resource/rsvps.txt'

    @input = input
    @output = 'automated_name_entry.html'
    @company = event
    @visiting = visiting
    @visit_date = visit_date
    @start_time = start_time
    @end_time = end_time
    @script = []
    @rsvps = ""
  end

  def emit
    load_names
    report
    build
    write
  end

  def load_names
    @rsvps = read_names_from_input_file
  end

  def build
    create_selenium_script(@rsvps)
  end

  def report
    puts "Writing #{@output} with #{name_count} rsvps"
  end

  def write(output=@output)
    write_script_to_output(@script, output)
  end

  def name_count
    @rsvps.size
  end

  def create_first_entry
    first, last = parse_name(@rsvps.first)
    @rsvps.delete_at(0)
    return first_entry(first, last)
  end

  def parse_name(full_name)
    first, last = full_name.split(" ")
    last = "Unknown" if last == ""
    return first, last
  end

  private
  def create_selenium_script(rsvps)
    @script << create_script_header
    @script << create_first_entry

    rsvps.each_with_index do |rsvp, index|
      first, last = parse_name(rsvp)
      count = index%10 + 1
      if count == 1 && index != 0
        @script << "<tr>\n"
        @script << "<td>clickAndWait</td>\n"
        @script << "<td>More</td>\n"
        @script << "<td></td>\n"
        @script << "</tr>\n"
      end
      type_it("first#{count}", first, @script)
      type_it("last#{count}", last, @script)
      type_it("company#{count}", @company, @script)
    end
    @script << create_script_footer
  end

  def first_entry(first, last)
    return <<eos
        <tr>
          <td>type</td>
          <td>firstName</td>
          <td>#{first}</td>
        </tr>
        <tr>
          <td>type</td>
          <td>lastName</td>
          <td>#{last}</td>
        </tr>
        <tr>
          <td>type</td>
          <td>companyName</td>
          <td>#{@company}</td>
        </tr>
        <tr>
          <td>select</td>
          <td>visiting</td>
          <td>label=#{@visiting}</td>
        </tr>
        <tr>
          <td>click</td>
          <td>emailhost</td>
          <td></td>
        </tr>
        <tr>
          <td>type</td>
          <td>purpose</td>
          <td>#{@company}</td>
        </tr>
        <tr>
          <td>type</td>
          <td>destination</td>
          <td>25th - ThoughtWorks, Inc.</td>
        </tr>
        <tr>
          <td>select</td>
          <td>startVisit</td>
          <td>label=#{@start_time}</td>
        </tr>
        <tr>
          <td>type</td>
          <td>dateStart</td>
          <td>#{@visit_date}</td>
        </tr>
        <tr>
          <td>select</td>
          <td>endVisit</td>
          <td>label=#{@end_time}</td>
        </tr>
        <tr>
          <td>type</td>
          <td>dateEnd</td>
          <td>#{@visit_date}</td>
        </tr>
        <tr>
          <td>clickAndWait</td>
          <td>more_in_group</td>
          <td></td>
        </tr>
eos
  end

  def read_names_from_input_file
    IO.readlines(@input)
  end

  def write_script_to_output(script=@script, output=@output)
    File.open(output, 'w'){|f| f.write(script)}
  end

  def create_script_header
    return <<eos
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
        <head profile="http://selenium-ide.openqa.org/profiles/test-case">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <link rel="selenium.base" href="" />
        <title>automated_checkin</title>
        </head>
        <body>
            <table cellpadding="1" cellspacing="1" border="1">
                <thead>
                    <tr><td rowspan="1" colspan="3">automated_checkin</td></tr>
                    </thead><tbody>
                    <tr>
                      <td>open</td>
                      <td>/ivisitor/DashBoard</td>
                      <td></td>
                    </tr>
                    <tr>
                      <td>click</td>
                      <td>5</td>
                      <td></td>
                    </tr>
                    <tr>
                      <td>selectFrame</td>
                      <td>CONTENT</td>
                      <td></td>
                    </tr>
eos
  end

  def create_script_footer
    return <<eos
              <tr>
                <td>clickAndWait</td>
                <td>Save</td>
                <td></td>
              </tr>
            </tbody></table>
          </body>
        </html>
eos
  end

  def type_it(field, value, script)
    script << "<tr>\n"
    script << "<td>type</td>\n"
    script << "<td>#{field}</td>\n"
    script << "<td>#{value}</td>\n"
    script << "</tr>\n"
  end

end
