module Shhh
  module Commands
    module Core
      module Secrets
        
        COMMENT_REPLACEMENT_REGEX = /^([^#]*)#\s*shhh\(([a-zA-Z_]+)\)\s*$/
        
        def add_secret(path, key, value)
          path_key = File.basename(path)
          secrets[path_key] ||= {}
          secrets[path_key][key] = value;
        end
      
        def get_secret(path, key)
          path_key = File.basename(path)
          secrets[path_key][key] if secrets[path_key] && secrets[path_key][key]
        end
      
        def write_secrets  
          write_file(secrets_path, secrets.to_yaml)
        end
        
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