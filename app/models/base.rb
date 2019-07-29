class Base
  include ActiveModel::Model

  class << self
    def account
      'demo'
    end

    def set_default_policy
      api.load_policy('root', root_policy)
    end

    def root_policy
      <<-POLICY
- !policy conjur
- !policy
  id: resources
  body:
    - !policy
      id: databases
      body:
        - !policy staging
        - !policy production
- !policy
  id: applications
  body:
    - !policy development
    - !policy staging
    - !policy integration
    - !policy production
POLICY
    end

    def api
      @api ||= begin
        Conjur.configuration.account = account
        Conjur.configuration.appliance_url = 'https://conjur/api'
        OpenSSL::SSL::SSLContext::DEFAULT_CERT_STORE.add_file '/opt/certs/conjur-master.local.pem'

        Conjur::API.new_from_key('admin', 'mqx5vwdkr1z4z1eq6c2m02kqe5cpy0z3xhw2n02aq5n6e3qabpwk')
        # Conjur::API.new_from_key('admin', ENV['API_KEY'])
      end
    end
  end
end
