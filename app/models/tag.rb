class Tag < ActiveRecord::Base

  validates_presence_of :value

  before_save :strip_value

  private

    def strip_value
      self.value.strip!
    end

end
