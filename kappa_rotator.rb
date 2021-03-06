require 'mini_magick'

fps = ARGV[0].to_i
inputKappa = ARGV[1]
kappaName = inputKappa.split('.').first

if kappaName.split('/').length > 1
  kappaName = 'rolling_' + kappaName.split('/').last
end

for i in 0..fps
  kappa = MiniMagick::Image.open("#{inputKappa}")

  kappa.combine_options do |kappaToRotate|
    kappaToRotate.distort('SRT', "#{i*(360/fps)}")
    kappaToRotate.background('transparent')
    kappaToRotate.virtual_pixel('transparent')
  end

  kappa.write("#{i}.png")
end

MiniMagick::Tool::Convert.new do |convert|

  convert.dispose('previous')

  for i in 0..fps
    convert.page('+0+0', "#{i}.png")
    convert.delay('10')
  end

  convert.loop('0')

  convert << "#{kappaName}.gif"
end
