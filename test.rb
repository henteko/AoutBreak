require 'redis'

BASE_IP = "127.0.0.1"
BASE_HOST = "testdocker.com"
base_port = 3000

redis = Redis.new(:host => "127.0.0.1", :port => 6379)

port = base_port + redis.dbsize.to_i
puts "Input app name: "
app_name = STDIN.gets
app_name = app_name.chomp

exit if app_name == ""


system("docker build -t henteko/rails .")
run_command = "docker run -d -p " + port.to_s + ":3000 henteko/rails"
system(run_command)

puts app_name + '.' + BASE_HOST
puts BASE_IP + ':' + port.to_s
redis.set(app_name + '.' + BASE_HOST, BASE_IP + ':' + port.to_s)
