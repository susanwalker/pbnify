require 'tempfile'

module PbnConverter
  def self.update(request)
    # TODO figure out later
    input_path =
      ActiveStorage::Blob.service.send(:path_for, request.input_image.key)
    output_path = generate_pbnified(input_path)
    request.output_image.attach(io: File.open(output_path), filename: 'output.png')
  end

  def self.generate_pbnified(input_path)
    # TODO: figure this out later
    color_map = spit_out_colors(input_path)
    color_map = remove_insignificant_colors(color_map)

    output_path = remove_colors_and_add_numbers(input_path, color_map)
    return output_path
  end

  def self.spit_out_colors(input_path)
    output = `convert #{input_path} -fuzz 10% -transparent white sparse-color:-`
    # output is of the form x,y,color x,y,color
    string_regex = /(\d*),(\d*),(.*)/

    # { color1 => [x1, y1], color2 = [x2, y2] }
    output.split(' ').map do |string|
      string.match(string_regex)
    end.inject({}) do |r, s|
      r.merge!(s[3] => [s[1], s[2]])
    end
  end

  def self.remove_insignificant_colors(color_map)
    # TODO: remove insignificant colors with fuzz feature
    color_map
  end

  def self.remove_colors_and_add_numbers(input_path, color_map)
    pointsize = 5

    transparent_string =
      color_map.keys.map do |color|
        "-transparent '#{color}'"
      end.join(' ')

    text_string =
      color_map.values.each_with_index.map do |pos, i|
        "text #{pos[0].to_i / pointsize},#{pos[1].to_i / pointsize} '(#{i})'"
      end.join(' ')

    # we want two different files to be created if two different requests are
    # being processed that's why we use tempfile which creates random file names
    temp_output = Tempfile.new(['image_output', '.png'])

    puts <<-COMMAND
    convert #{input_path} -fuzz 10% \
     #{transparent_string} \
     -font Arial -pointsize #{pointsize} -draw "gravity south fill black \
     #{text_string} \
     " \
     -border 20 #{temp_output.path}
     COMMAND

    `convert #{input_path} -fuzz 10% \
     #{transparent_string} \
     -font Arial -pointsize #{pointsize} -draw "gravity south fill black \
     #{text_string} \
     " \
     -border 20 #{temp_output.path}`

     temp_output.path
  end
end
