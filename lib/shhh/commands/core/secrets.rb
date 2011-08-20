module Shhh
  module Commands
    module Core
      module Secrets

        COMMENT_REPLACEMENT_REGEX = /^([^#]*)#\s*shhh\(([a-zA-Z_]+)\)\s*$/

        # Add a key and value to the secrets file for the given file.
        #
        # path - The String path to the file containing the secret.
        # key - The String key to store the value as
        # value - The String value to store
        def add_secret(path, key, value)
          path_key = File.basename(path)
          secrets[path_key] ||= {}
          secrets[path_key][key] = value
        end

        # Get a secret value for the given file and key.
        #
        # path - The String path to the file that contains the secret
        # key - The String key to retrieve the value for
        #
        # Returns the string value from the secrets file for the given key.
        def get_secret(path, key)
          path_key = File.basename(path)
          secrets[path_key][key] if secrets[path_key] && secrets[path_key][key]
        end

        # Write the internal secrets hash to the secrets file as YAML.
        def write_secrets
          write_file(secrets_path, secrets.to_yaml)
        end

        # The secrets hash.
        #
        # Returns the secrets hash if a a secrets file exists, or an empty hash
        # if it does not.
        def secrets
          @secrets ||= if File.exist?(secrets_path)
            info "Loading existing secrets from #{secrets_path}"
            YAML.load_file(secrets_path)
          else
            {}
          end
        end
      end
    end
  end
end
