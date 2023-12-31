class Place < OpenStruct
  def self.rendered_fields
    %i[id name status street city zip country overall]
  end
end
