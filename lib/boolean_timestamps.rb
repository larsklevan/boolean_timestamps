require 'boolean_timestamps/version'
require 'active_support/concern'

module BooleanTimestamps
  extend ActiveSupport::Concern

  class_methods do
    def boolean_timestamps(*attributes)
      attributes.each do |timestamp_attribute|
        boolean_attribute = timestamp_attribute.to_s.gsub('_at', '')
        define_method boolean_attribute do
          send("#{timestamp_attribute}?")
        end
        define_method "#{boolean_attribute}?" do
          send("#{timestamp_attribute}?")
        end
        define_method "#{boolean_attribute}=" do |value|
          boolean_value = ActiveRecord::Type::Boolean.new.type_cast_from_database(value)
          unless boolean_value && send("#{timestamp_attribute}?")
            timestamp = boolean_value ? Time.zone.now : nil
            send("#{timestamp_attribute}=", timestamp)
          end
        end
      end
    end
  end
end
ActiveSupport.on_load(:active_record) do
  include BooleanTimestamps
end