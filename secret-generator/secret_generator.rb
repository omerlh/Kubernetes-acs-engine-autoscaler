require 'erb'
# With the help from the following SO answers:
# https://stackoverflow.com/a/2621023/4792970
# https://stackoverflow.com/questions/25817007/how-do-i-save-the-text-of-puts-in-ruby-to-a-txt-file

require 'json'
require 'base64'

if (ARGV.length < 1)
    puts "usages: ruby secret_generator.rb <path_to_azuredeploy.parameters.json>"
end

json = File.read(ARGV[0])
obj = JSON.parse(json)["parameters"]

@app_id = Base64.strict_encode64(obj["servicePrincipalClientId"]["value"])
@app_secret = Base64.strict_encode64(obj["servicePrincipalClientSecret"]["value"])
@kubeconfig_private_key = Base64.strict_encode64(obj["kubeConfigPrivateKey"]["value"])
@client_private_key = Base64.strict_encode64(obj["clientPrivateKey"]["value"])
@ca_private_key = Base64.strict_encode64(obj["caPrivateKey"]["value"])

template = File.read('./secret.yaml.erb')
renderer = ERB.new(template).result( binding )

File.open("secrets.yaml","w") do |f|
    f.puts renderer
end

puts "done"