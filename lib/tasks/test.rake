


namespace :test do
  desc ""
  task :publish => :environment do
    Conjur.configuration.account = 'demo'
    Conjur.configuration.appliance_url = 'https://conjur/api'

    api = Conjur::API.new_from_key('admin', 'j3hasr26w3bf41eabeyw142e5yj13j3qbw2a1de903tcffdn29y9xrs')
    policy = File.read('policy.yml')
    policy_result = api.load_policy("root", policy)

    OpenSSL::SSL::SSLContext::DEFAULT_CERT_STORE.add_file 'conjur.pem'
        # Click.cleanup!
  end
end
