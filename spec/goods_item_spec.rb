require 'spec_helper'

describe ProcessingKzRav::GoodsItem do

  it 'creates goods item' do
    goods_item = ProcessingKzRav::GoodsItem.new(title: 'Cool stuff', good: 124, amount: 1200.00, currency_code: 398)
    expect(goods_item.name_of_goods).to eq('Cool stuff')
  end
end
