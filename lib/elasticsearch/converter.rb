# frozen_string_literal:true
require 'json'

module Elasticsearch
  class Converter
    def self.csv_row_to_hash(row, column_names)
      hsh = {}
      column_names.zip(row).each do |key, value|
        if (key == 'DOB' || key == 'DateReg') && !value.nil?
          a = value.split('/')
          value = "#{a[2]}-#{a[0]}-#{a[1]}"
        end
        i = 2
        orig_key = key
        while hsh.keys.include?(key) do
          key = "#{orig_key}_#{i}"
          i += 1
        end
        hsh[key] = value
      end
      hsh
    end
  end
end
