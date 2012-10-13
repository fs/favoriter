# encoding: utf-8

require 'spec_helper'

describe Favoriter::Tweet::Content do
  let(:text) { 'text' }
  let(:content) { Favoriter::Tweet::Content.new(text) }
  subject { content }

  context 'tweet with text only' do
    let(:text) { 'text without links' }

    its(:type) { should == 'text' }
    its(:image) { should be_nil }
    its(:title) { should be_nil }
    its(:excerpt) { should be_nil }
    its(:text) { should == 'text without links' }
    its(:url) { should be_nil }
  end

  context 'tweet with link to image', use_vcr_cassette('readability/image') do
    let(:text) { 'text with image http://t.co/8PiJlVNI' }

    its(:type) { should == 'image' }
    its(:image) { should == 'http://cs403323.userapi.com/v403323881/4cf5/cCB4uBFxAaQ.jpg' }
    its(:title) { should be_nil }
    its(:excerpt) { should be_nil }
    its(:text) { should == 'text with image' }
    its(:url) { should == 'http://cs403323.userapi.com/v403323881/4cf5/cCB4uBFxAaQ.jpg' }
  end

  context 'text with link to article with lead image url', use_vcr_cassette('readability/article_with_image') do
    let(:text) { 'text with image http://t.co/js0CqaK4' }

    its(:type) { should == 'article_with_image' }
    its(:image) { should == 'http://img.lenta.ru/photo/2012/10/11/xcom1/pic001.jpg' }
    its(:title) { should == 'Враг известен' }
    its(:excerpt) { should =~ /&#x41F;&#x43E;&#x447;&#x442;&#x438;/ }
    its(:text) { should == 'text with image' }
    its(:url) { should == 'http://lenta.ru/photo/2012/10/11/xcom1/' }
  end

  context 'text with link to article without lead image url', use_vcr_cassette('readability/article_without_image') do
    let(:text) { 'text without image http://t.co/taTxzJdi' }

    its(:type) { should == 'article_without_image' }
    its(:image) { should be_nil }
    its(:title) { should == 'По горячим следам «404 феста»' }
    its(:excerpt) { should =~ /&#x41D;&#x430;&#xA0;&#x43F;&#x440;&#x43E;&#x448;&#x43B;&#x44B;&#x445;/ }
    its(:text) { should == 'text without image' }
    its(:url) { should == 'http://infotanka.ru/app/all/po-goryachim-sledam-404-festa/' }
  end

  context 'text with two links. First is article with image', use_vcr_cassette('readability/article_with_image_2') do
    let(:text) { 'text with two links http://t.co/js0CqaK4 http://t.co/8PiJlVNI' }

    its(:image) { should == 'http://img.lenta.ru/photo/2012/10/11/xcom1/pic001.jpg' }
    its(:title) { should == 'Враг известен' }
    its(:excerpt) { should =~ /&#x41F;&#x43E;&#x447;&#x442;&#x438;/ }
    its(:text) { should == 'text with two links' }
    its(:url) { should == 'http://lenta.ru/photo/2012/10/11/xcom1/' }
  end
end