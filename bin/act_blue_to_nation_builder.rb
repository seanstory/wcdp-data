require 'csv'

# TODO: handle 2-line addresses
# TODO: email validations
csv = CSV.new(File.new('/path/to/actblue.csv'))
rows = csv.read
clean_rows = rows[1..-1].each_with_object([]) do |row, new_rows|
  new_row = []
  name = row[0]
  name_chunks = name.split(' ')
  if name_chunks.size == 2
    first_name = name_chunks[0]
    last_name = name_chunks[1]
    middle_name = ''
  elsif name_chunks.size == 3
    first_name = name_chunks[0]
    middle_name = name_chunks[1]
    last_name = name_chunks[2]
    if middle_name == 'De'
      last_name = "#{middle_name} #{last_name}"
      middle_name = ''
    end
    puts "non-standard name: #{name}"
  else
    raise "This name doesn't parse: '#{name}'"
  end
  new_row << first_name
  new_row << middle_name
  new_row << last_name
  row[1..-1].each do |col|
    new_row << col
  end
  new_rows << new_row
end
clean_rows = clean_rows.uniq
CSV.open('clean.csv', 'wb') do |cleaned_csv|
  clean_rows.each do |row|
    cleaned_csv << row
  end
end
