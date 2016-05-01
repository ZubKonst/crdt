%w[ app config ].each do |folder|
  Dir[File.join(File.dirname(__FILE__), folder, '*.rb')].each {|file| require file }
end

