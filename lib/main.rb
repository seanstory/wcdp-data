require 'awesome_print'
require 'csv'
require_relative 'NGPVAN/client'

class Main

  attr_reader :client

  def initialize
    @client = NGPVAN::Client.build_client!
  end


  # Not super useful - was just trying to find users in the sandbox with phone numbers
  def find_phone_user
    user_with_phone = nil
    i = 1
    until user_with_phone
      user = client.get_person_by_id(i)
      puts "Looking at user: #{user.vanId} with name: #{user.firstName} #{user.lastName}"
      if user.errors&.any? || !user.phones.nil?
        user_with_phone = user
        break
      end
      i += 1
    end
    ap user_with_phone.to_h
  end


  # TODO needs a test
  def validate
    csv = CSV.new(File.new(ENV['VOTEBUILDER_CSV'])) # TODO better arg passing
    rows = csv.read[1..-1] # skip the header
    ids = rows.map { |row| row[0] }
    ids.each do |id|
      person = client.get_person_by_id(id.to_i)
      if person.errors&.any?
        ap person.to_h
        raise StandardError("Could not find user #{id}")
      end
      puts "Looking at #{person_to_s(person)}"
      should_update=false
      if person.phones
        person.phones.each do |phone|
          is_cell = is_cell?(phone.phoneNumber)
          status_id = phone.isCellStatus.statusId
          puts "Detected #{phone.phoneNumber} as #{is_cell ? '' : 'not'} a cell number. Current status: #{phone.isCellStatus.statusName}."
          if is_cell && status_id != 1 # 1 => "Verified Cell"
            puts "Updating it to 'Verified Cell'"
            phone.isCellStatus = Hashie.Mash.new(
              {
                :statusId => 1,
                :statusName => 'Verified Cell'
              }
            )
            should_update = true
          elsif !is_cell && status_id == 1 || status_id == 2
            puts "Updating it to 'Likely Not a Cell'"
            phone.isCellStatus = Hashie.Mash.new(
              {
                :statusId => 3,
                :statusName => 'Likely Not a Cell'
              }
            )
            should_update = true
          else
            puts 'Leaving it as-is.'
          end

          if should_update
            client.update_person(person)
          end
        end
      else
        puts "Person #{person_to_s(person)} has no phones"
      end
    end
  end

  def is_cell?(phone_number)
    # TODO
    false
  end

  def person_to_s(person)
    "#{person.vanId} (#{person.firstName} #{person.lastName})"
  end
end

if ARGV[0]
  Main.new.send(ARGV[0].to_sym)
else
  puts "ERROR: Provide an argument"
end
