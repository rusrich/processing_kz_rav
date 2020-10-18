require 'spec_helper'

feature 'Transaction' do

  before do

    ProcessingKzRav.config do |config|
      config.wsdl = 'spec/CNPMerchantWebService_test.wsdl'
      config.host = 'https://test.processing.kz/CNPMerchantWebServices/services/CNPMerchantWebService'
      config.merchant_id = '000000000000115'
      # config.merchant_id = '000000000000098'
      config.language_code = 'en'
      config.currency_code = 398
    end

    @goods = []
    @goods << ProcessingKzRav::GoodsItem.new(title: 'Cool stuff', good_id: 124, amount: 1200.00)
    @goods << ProcessingKzRav::GoodsItem.new(title: 'Mega stuff', good_id: 125, amount: 120.99)

    @good = ProcessingKzRav::GoodsItem.new(title: 'One stuff', good_id: 125, amount: 12070)
    @good_additional = ProcessingKzRav::GoodsItem.new(title: 'Additional stuff', good_id: 126, amount: 5030)
  end

  it 'handles total amount correctly (*100)' do
    request = ProcessingKzRav::StartTransaction.new(order_id: rand(1..1000000), goods_list: @goods, return_url: 'http://localhost')
    expect(request.total_amount).to eq(132099)
  end

  it 'makes a successful start transaction request' do
    request = ProcessingKzRav::StartTransaction.new(order_id: rand(1..1000000), goods_list: @goods, return_url: 'http://localhost')
    expect(request.success).to eq(true)
  end

  it 'makes a unsuccessful star transaction request' do
    request = ProcessingKzRav::StartTransaction.new(merchant_id: 'bad_id', goods_list: @goods)
    expect(request.success).to eq(false)
  end

  it 'makes request for transaction status which is pending' do
    request = ProcessingKzRav::StartTransaction.new(order_id: rand(1..1000000), goods_list: @goods, return_url: 'http://localhost')
    status = ProcessingKzRav::GetTransaction.new(customer_reference: request.customer_reference)
    expect(status.transaction_status).to eq('PENDING_CUSTOMER_INPUT')
  end

  it 'makes request for transaction status which is authorised' do
    request = ProcessingKzRav::StartTransaction.new(order_id: rand(1..1000000), goods_list: @goods, return_url: 'http://google.com')
    visit request.redirect_url
    fill_in 'pan', with: '4012 0010 3844 3335'
    select  '01', from: 'expiryMonth'
    select  '2021', from: 'expiryYear'
    fill_in 'cardHolder', with: 'IVAN INAVOV'
    fill_in 'cardSecurityCode', with: '123'
    fill_in 'cardHolderEmail', with: 'test@processing.kz'
    fill_in 'cardHolderPhone', with: '87771234567'
    click_button 'Pay'
    sleep 5
    status = ProcessingKzRav::GetTransaction.new(customer_reference: request.customer_reference)
    expect(status.transaction_status).to eq('PAID')
    click_button 'Return'
  end

  it 'successfuly makes all process of transaction through coder friendly interface' do
    start = ProcessingKzRav.start(order_id: rand(1..1000000), goods_list: @good, return_url: 'http://google.com')
    visit start.redirect_url
    fill_in 'pan', with: '4012 0010 3844 3335'
    select  '01', from: 'expiryMonth'
    select  '2021', from: 'expiryYear'
    fill_in 'cardHolder', with: 'MARIA SIDOROVA'
    fill_in 'cardSecurityCode', with: '123'
    fill_in 'cardHolderEmail', with: 'test@processing.kz'
    fill_in 'cardHolderPhone', with: '87011234567'
    click_button 'Pay'
    sleep 5
    ProcessingKzRav.complete(customer_reference: start.customer_reference, transaction_success: true)
    status = ProcessingKzRav.get(customer_reference: start.customer_reference)
    expect(status.transaction_status).to eq('PAID')
    click_button 'Return'
  end

  # it 'successfuly declines payment process of transaction through coder friendly interface' do
  #   start = ProcessingKzRav.start(order_id: rand(1..1000000), goods_list: @good, return_url: 'http://google.com')
  #   visit start.redirect_url
  #   fill_in 'pan', with: '4012 0010 3844 3335'
  #   select  '01', from: 'expiryMonth'
  #   select  '2021', from: 'expiryYear'
  #   fill_in 'cardHolder', with: 'MARIA SIDOROVA'
  #   fill_in 'cardSecurityCode', with: '123'
  #   fill_in 'cardHolderEmail', with: 'test@processing.kz'
  #   fill_in 'cardHolderPhone', with: '87011234567'
  #   click_button 'Pay'
  #   sleep 20
  #   ProcessingKzRav.complete(customer_reference: start.customer_reference, transaction_success: false)
  #   status = ProcessingKzRav.get(customer_reference: start.customer_reference)
  #   expect(status.transaction_status).to eq('REVERSED')
  #   click_button 'Return'
  # end

  it 'with 2 MIDs' do
    start = ProcessingKzRav.start(order_id: rand(1..1000000), goods_list: @good, return_url: 'http://google.com', additional_goods_list: @good_additional, add_mid: '000000000000098')

    visit start.redirect_url
    fill_in 'pan', with: '4012 0010 3844 3335'
    select  '01', from: 'expiryMonth'
    select  '2021', from: 'expiryYear'
    fill_in 'cardHolder', with: 'MARIA SIDOROVA'
    fill_in 'cardSecurityCode', with: '123'
    fill_in 'cardHolderEmail', with: 'test@processing.kz'
    fill_in 'cardHolderPhone', with: '87011234567'
    click_button 'Pay'
    sleep 5
    ProcessingKzRav.complete(customer_reference: start.customer_reference, transaction_success: true)
    status = ProcessingKzRav.get(customer_reference: start.customer_reference)
    expect(status.transaction_status).to eq('PAID')
  end
end
