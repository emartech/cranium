class Cranium::Transformation::Sequence

  attr_reader :name



  def initialize(name)
    @name = name
  end



  def next_value
    if @current_value.nil?
      @current_value = Cranium::Database.connection["SELECT nextval('#{@name}') AS next_value"].first[:next_value]
    else
      @current_value += 1
    end
  end



  def flush
    Cranium::Database.connection.run "SELECT setval('#{@name}', #{@current_value})" unless @current_value.nil?
  end



  class << self

    def by_name(name)
      @sequences ||= {}
      if @sequences[name].nil?
        @sequences[name] = new name
        Cranium.application.after_import { @sequences[name].flush }
      end
      @sequences[name]
    end

  end

end
