module Ckeditor
  module Orm
    module ActiveRecord
      module AssetBase
        def self.included(base)
          base.send(:include, InstanceMethods)
          base.send(:extend, ClassMethods)
        end
        
        module ClassMethods
          def self.extended(base)
            base.class_eval do
              set_table_name "ckeditor_assets"
              
              belongs_to :assetable, :polymorphic => true
              
              attr_accessible :data, :assetable_type, :assetable_id, :assetable
            end
          end
        end
        
        module InstanceMethods
          
          def format_created_at
            created_at.strftime("%d.%m.%Y")
          end
          
          def url_content
	          url
	        end
	
	        def url_thumb
	          url(:thumb)
	        end
          
          def as_json(options = nil)
            options = {
              :methods => [:url_content, :url_thumb, :size, :filename, :format_created_at],
              :root => "asset"
            }.merge(options || {})
            
            super options
          end
        end
      end
    end
  end
end
