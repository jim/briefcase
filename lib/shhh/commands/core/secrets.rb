module Shhh
  module Commands
    module Core
      module Secrets
        def add_secret(path, key, value)
          path_key = File.basename(path)
          @new_secrets ||= {}
          @new_secrets[path_key] ||= {}
          @new_secrets[path_key][key] = value;
        end
      
        def write_secrets  
          current_secrets = read_secrets
          current_secrets.deep_merge!(@new_secrets || {})
          write_file(secrets_path, current_secrets.to_yaml)
        end
        
        def read_secrets
          if File.exist?(secrets_path)
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