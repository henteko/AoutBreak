require 'redis'
require 'route53'

BASE_IP = "127.0.0.1"
BASE_HOST = "example.com"
base_port = 3000

conn = Route53::Connection.new('your access key', 'your secret key')
zones = conn.get_zones
target_zone = nil
zones.each do |zone|
    if zone.name == BASE_HOST + '.'
          target_zone = zone
            end
end
if target_zone == nil
    puts "not target zone error"
      exit
end

redis = Redis.new(:host => "127.0.0.1", :port => 6379)

port = base_port + redis.dbsize.to_i
puts "Input app name: "
app_name = STDIN.gets
app_name = app_name.chomp

exit if app_name == ""

system("docker build -t henteko/rails .")
run_command = "docker run -d -p " + port.to_s + ":3000 henteko/rails"
system(run_command)

url = app_name + '.' + BASE_HOST
ip = BASE_IP + ':' + port.to_s
puts url
puts ip
redis.set(url, ip)

new_record = Route53::DNSRecord.new(url + '.',"CNAME","300",[target_zone.name], target_zone)
resp = new_record.create
puts resp
