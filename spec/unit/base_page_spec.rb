require 'spec_helper'
require_relative '../../lib/pages/base_page'
require_relative '../../lib/utils/driver_manager'

RSpec.describe BasePage do
  let(:mock_driver) { double('driver') }
  let(:mock_element) { double('element') }
  let(:base_page) { BasePage.new }

  before do
    allow(DriverManager).to receive(:driver).and_return(mock_driver)
  end

  describe '#initialize' do
    it 'sets the driver from DriverManager' do
      expect(base_page.driver).to eq(mock_driver)
    end
  end

  describe '#find_element' do
    it 'finds element using driver' do
      locator = { id: 'test-id' }
      expect(mock_driver).to receive(:find_element).with(locator).and_return(mock_element)
      
      result = base_page.find_element(locator)
      
      expect(result).to eq(mock_element)
    end
  end

  describe '#find_elements' do
    it 'finds multiple elements using driver' do
      locator = { class: 'test-class' }
      elements = [mock_element, mock_element]
      expect(mock_driver).to receive(:find_elements).with(locator).and_return(elements)
      
      result = base_page.find_elements(locator)
      
      expect(result).to eq(elements)
    end
  end

  describe '#tap' do
    it 'clicks on the element' do
      locator = { id: 'button' }
      expect(mock_driver).to receive(:find_element).with(locator).and_return(mock_element)
      expect(mock_element).to receive(:click)
      
      base_page.tap(locator)
    end
  end

  describe '#send_keys' do
    it 'sends keys to the element' do
      locator = { id: 'input' }
      text = 'test text'
      expect(mock_driver).to receive(:find_element).with(locator).and_return(mock_element)
      expect(mock_element).to receive(:send_keys).with(text)
      
      base_page.send_keys(locator, text)
    end
  end

  describe '#clear_and_send_keys' do
    it 'clears and sends keys to the element' do
      locator = { id: 'input' }
      text = 'new text'
      expect(mock_driver).to receive(:find_element).with(locator).and_return(mock_element)
      expect(mock_element).to receive(:clear)
      expect(mock_element).to receive(:send_keys).with(text)
      
      base_page.clear_and_send_keys(locator, text)
    end
  end

  describe '#get_text' do
    it 'returns text from the element' do
      locator = { id: 'label' }
      expected_text = 'Sample Text'
      expect(mock_driver).to receive(:find_element).with(locator).and_return(mock_element)
      expect(mock_element).to receive(:text).and_return(expected_text)
      
      result = base_page.get_text(locator)
      
      expect(result).to eq(expected_text)
    end
  end

  describe '#is_displayed?' do
    it 'returns true when element is displayed' do
      locator = { id: 'visible' }
      expect(mock_driver).to receive(:find_element).with(locator).and_return(mock_element)
      expect(mock_element).to receive(:displayed?).and_return(true)
      
      result = base_page.is_displayed?(locator)
      
      expect(result).to be true
    end

    it 'returns false when element is not found' do
      locator = { id: 'not-found' }
      expect(mock_driver).to receive(:find_element).with(locator).and_raise(StandardError)
      
      result = base_page.is_displayed?(locator)
      
      expect(result).to be false
    end
  end

  describe '#hide_keyboard' do
    it 'hides keyboard when shown' do
      expect(mock_driver).to receive(:is_keyboard_shown).and_return(true)
      expect(mock_driver).to receive(:hide_keyboard)
      
      base_page.hide_keyboard
    end

    it 'does not raise error when keyboard is not shown' do
      expect(mock_driver).to receive(:is_keyboard_shown).and_raise(StandardError)
      
      expect { base_page.hide_keyboard }.not_to raise_error
    end
  end
end
