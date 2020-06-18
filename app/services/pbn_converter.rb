require 'tempfile'

module PbnConverter
  FUZZ_PERCENTAGE = 10
  MINIMUM_FREQUENCY = 60

  # Public

  def self.update(request)
    # This returns a file path to the input
    input_path =
      ActiveStorage::Blob.service.send(:path_for, request.input_image.key)
    output_path = generate_pbnified(input_path)
    request.output_image.attach(io: File.open(output_path), filename: 'output.png')
  end

  # Private

  def self.generate_pbnified(input_path)
    color_map = spit_out_colors(input_path)

    remove_colors_and_add_numbers(input_path, color_map)
  end

  def self.spit_out_colors(input_path)
    output = `convert #{input_path} -fuzz 10% -transparent white sparse-color:-`
    # output is of the form x,y,color x,y,color
    string_regex = /(\d*),(\d*),(.*)/

    # { color1 => [x1, y1, frequency], color2 => [x2, y2, frequency2] }
    output.split(' ').map do |string|
      string.match(string_regex)
    end.inject({}) do |color_map, element|
      old_color = color_map[element[3]]

      if old_color.nil?
        frequency = 1

        color_map.merge!(element[3] => [element[1], element[2], frequency])
      else
        frequency = old_color[2] + 1

        if add_element_to_map?(element, color_map)
          color_map.merge!(element[3] => [element[1], element[2], frequency])
        else
          color_map.merge!(
            element[3] => [old_color[0], old_color[1], frequency]
          )
        end
      end
    end
  end

  def self.add_element_to_map?(element, color_map)
    old_color = color_map[element[3]]

    old_element = [:element, old_color[0], old_color[1], element[3]]

    average_distance_of_old =
      average_distance_of_element(old_element, color_map)

    average_distance_of_new =
      average_distance_of_element(element, color_map)

    average_distance_of_new > average_distance_of_old
  end

  def self.average_distance_of_element(element, color_map)
    distances_array =
      color_map.reject do |key, value|
        key == element[3]
      end.map do |key, value|
        # (absolute values) differences between x's and y's and add them
        (value[0].to_i - element[1].to_i).abs +
          (value[1].to_i - element[2].to_i).abs
      end

    sum_of_distances =
      distances_array.inject(0) { |sum, element| sum + element }

    sum_of_distances / distances_array.size.to_f
  end

  def self.remove_insignificant_colors(color_map)
    final_map = {}
    color_map.each do |color1, new_color|
      next if new_color[2] < MINIMUM_FREQUENCY

      color_within_fuzz =
        final_map.keys.find do |color2|
          fuzz_percentage(color1, color2) < FUZZ_PERCENTAGE
        end

      old_color = color_map[color_within_fuzz]

      # compare frequencies of colors
      if old_color.nil? || (new_color[2] > old_color[2])
        final_map.merge!(color1 => new_color)
      end
    end

    final_map
  end

  def self.fuzz_percentage(color1, color2)
    fr1 = fuzz_radius(color1)
    fr2 = fuzz_radius(color2)
    (fr1 - fr2).abs / fr1 * 100
  end

  def self.fuzz_radius(color)
    regex = /srgba\((\d*),(\d*),(\d*),(\d*)\)/
    color_components = color.match(regex)
    fuzz_radius_sq =
      color_components[1].to_i^2 +
        color_components[2].to_i^2 +
          color_components[3].to_i^2
    Math.sqrt(fuzz_radius_sq)
  end

  def self.remove_colors_and_add_numbers(input_path, color_map)
    pointsize = 10

    color_map = remove_insignificant_colors(color_map)

    transparent_string =
      color_map.keys.map do |color|
        "-opaque '#{color}'"
      end.join(' ')

    text_string =
      color_map.values.each_with_index.map do |pos, i|
        "text #{pos[0]},#{pos[1]} '(#{i})'"
      end.join(' ')

    # we want two different files to be created if two different requests are
    # being processed that's why we use tempfile which creates random file names
    temp_output = Tempfile.new(['image_output', '.png'])


    `convert #{input_path} -fuzz 10% \
     -fill white #{transparent_string} \
     -font Arial -pointsize #{pointsize} -fill black -draw "\
     #{text_string} \
     " \
     -border 4 #{temp_output.path}`

     temp_output.path
  end
end
