class FraudDetection
  def parse_email(email)
    email_split = email.downcase.split("@")
    username = email_split[0].gsub(".", "").gsub(/(\+.*)/, "")
    domain = email_split[1]

    "#{username}@#{domain}"
  end

  def parse_address(address)
    address.downcase
      .gsub("st.", "street")
      .gsub("rd.", "road")
  end

  def parse_state(state)
    state.downcase
      .gsub("il", "illinois")
      .gsub("ca", "california")
      .gsub("ny", "new york")
  end

  def parse_city(city)
    city.downcase
  end

  def parse_line(line, hash)
    tokens = line.split(",")
    parsed_line = {
        :order_id => tokens[0].to_i,
        :card_nr => tokens[7],
        :email_key => "#{tokens[1]}#{parse_email(tokens[2])}",
        :address_key => "#{tokens[1]}#{parse_address(tokens[3])}#{parse_city(tokens[4])}#{parse_state(tokens[5])}#{tokens[6]}",
        :fraud => false
    }

    result = check_hash(parsed_line[:email_key], parsed_line, hash)
    if result.empty?
      result = check_hash(parsed_line[:address_key], parsed_line, hash)
    end

    result
  end

  def detect(lines)
    hash = {}
    result = []

    lines.each do |line|
      result.concat(parse_line(line, hash))
    end

    result.sort
  end

  private

  def check_hash(key, line, hash)
    result = []

    if hash.has_key?(key)
      fraud_lines = hash[key].select { |l| l[:card_nr] != line[:card_nr] }

      fraud_lines.each do |fl|
        unless fl[:fraud]
          fl[:fraud] = true
          result << fl[:order_id]
        end
      end

      unless fraud_lines.empty?
        line[:fraud] = true
        result << line[:order_id]
      end
    end

    hash[key] ||= []
    hash[key] << line

    result
  end
end

number_of_lines = STDIN.gets.chomp().to_i
fraud_detection = FraudDetection.new

hash = {}
result = []

number_of_lines.times do
  line = STDIN.gets.chomp()
  result.concat(fraud_detection.parse_line(line, hash))
end

STDOUT.puts result.sort.join(",")
