module ProcessingKzRav

  def self.start(*args)
    StartTransaction.new(*args)
  end

  def self.get(*args)
    GetTransaction.new(*args)
  end

  def self.complete(*args)
    CompleteTransaction.new(*args)
  end

  def self.good(*args)
    ProcessingKzRav::GoodsItem.new(*args)
  end
end
