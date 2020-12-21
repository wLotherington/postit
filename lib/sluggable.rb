module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug!
    class_attribute :slug_column
  end

  def to_param
    self.slug
  end

  def generate_slug!
    the_slug = to_slug(self.send(self.class.slug_column.to_sym))
    obj = self.class.find_by slug: the_slug
    counter = nil

    while obj && obj != self
      temp = the_slug + "-" + counter.to_s
      counter = counter ? 2 : counter + 1
      obj = self.class.find_by slug: temp
    end

    self.slug = counter ? the_slug + "-" + counter.to_s : the_slug
  end

  def to_slug(name)
    str = name
    str.gsub! /\s*[^A-Za-z0-9]\s*/, ' '
    str = str.strip
    str.gsub! /\s+/, "-"
    str.downcase
  end

  module ClassMethods
    def sluggable_column(col_name)
      self.slug_column = col_name
    end
  end
end