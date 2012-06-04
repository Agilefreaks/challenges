class FraudDetection
  def initialize
    @hash = {}
    @frauds = {}
  end

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
    state.downcase!
    state = state.gsub("il", "illinois").gsub("ca", "california").gsub("ny", "new york") if state.length == 2
    state
  end

  def parse_city(city)
    city.downcase
  end

  def parse_line(line)
    tokens = line.split(",")
    parsed_line = {
        :order_id => tokens[0].to_i,
        :email_key => "#{tokens[1]}_#{parse_email(tokens[2])}",
        :address_key => "#{tokens[1]}_#{parse_address(tokens[3])}_#{parse_city(tokens[4])}_#{parse_state(tokens[5])}_#{tokens[6]}",
        :card_nr => tokens[7]
    }

    check_hash(parsed_line)
  end

  def check_hash(line)
    [line[:email_key], line[:address_key]].each do |key|
      if @hash.has_key?(key) && !(fraud_lines = @hash[key].select { |l| l[:card_nr] != line[:card_nr] }).empty?
        fraud_lines.each do |l|
          @frauds[l[:order_id]] = true
        end
        @frauds[line[:order_id]] = true
      end

      @hash[key] ||= []
      @hash[key] << line
    end
  end

  def detect(lines)
    lines.each do |line|
      parse_line(line)
    end

    result
  end

  def result
    @frauds.keys.sort.join(",")
  end

end

#number_of_lines = STDIN.gets.chomp().to_i
#fraud_detection = FraudDetection.new
#
#number_of_lines.times do
#  line = STDIN.gets.chomp()
#  fraud_detection.parse_line(line)
#end
#
#STDOUT.puts fraud_detection.result
