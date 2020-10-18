require 'spec_helper'

describe ProcessingKzRav do

  it 'sets and returns merchant_id properly' do
    ProcessingKzRav.config do |config|
      config.merchant_id = '333000000000000'
    end
    expect(ProcessingKzRav::Config.merchant_id).to eq('333000000000000')
  end

  it 'sets and returns language_code properly' do
    ProcessingKzRav.config do |config|
      config.language_code = 'ru'
    end
    expect(ProcessingKzRav::Config.language_code).to eq('ru')
  end

  it 'restricts to set unsupported languages' do
    expect do
      ProcessingKzRav.config do |config|
        config.language_code = 'de'
      end
    end.to raise_error(UnsupportedLanguageError)
  end

  it 'sets and returns currency_code properly' do
    ProcessingKzRav.config do |config|
      config.currency_code = '398'
    end
    expect(ProcessingKzRav::Config.currency_code).to eq('398')
  end

  it 'sets and returns wsdl properly' do
    ProcessingKzRav.config do |config|
      config.wsdl = 'https://test.processing.kz/CNPMerchantWebServices/CNPMerchantWebService.wsdl'
    end
    expect(ProcessingKzRav::Config.wsdl).to eq('https://test.processing.kz/CNPMerchantWebServices/CNPMerchantWebService.wsdl')
  end

  it 'sets and returns host properly' do
    ProcessingKzRav.config do |config|
      config.host = 'https://test.processing.kz/CNPMerchantWebServices/services/CNPMerchantWebService'
    end
    expect(ProcessingKzRav::Config.host).to eq('https://test.processing.kz/CNPMerchantWebServices/services/CNPMerchantWebService')
  end
end
