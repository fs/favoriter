# encoding: utf-8

require 'spec_helper'

describe Favoriter::Tweet::Content do
  let(:content) { Favoriter::Tweet::Content.new(text) }
  let(:parsed_content) { nil }

  subject { content }

  before do
    content.parsed_content = parsed_content
  end

  context 'tweet with text only' do
    let(:text) { 'text without links' }

    it { should_not have_link }
    its(:type) { should == 'text' }

    its(:url) { should be_nil }
    its(:image) { should be_nil }
    its(:title) { should be_nil }
    its(:excerpt) { should be_nil }
    its(:text) { should == text }
  end

  context 'tweet with link' do
    let(:text) { 'text with link http://example.com/some-short-link' }

    describe '#prepare' do
      before do
        Favoriter::Tweet::ReadabilityParser.stub(:new).and_return(double('parser', cached_content: 'parsed_content'))
      end

      it 'should call ReadabilityParser' do
        Favoriter::Tweet::ReadabilityParser.should_receive(:new).with('http://example.com/some-short-link')
        content.prepare
      end

      it 'should save parsed content' do
        content.prepare
        content.parsed_content.should == 'parsed_content'
      end
    end

    context 'to image' do
      let(:parsed_content) do
        {
          'url' => 'http://example.com/image.jpeg'
        }
      end

      it { should have_link }
      its(:type) { should == 'image' }
      its(:url) { should == 'http://example.com/image.jpeg' }
      its(:image) { should == 'http://example.com/image.jpeg' }
    end

    context 'to article with lead image url' do
      let(:parsed_content) do
        {
          'url' => 'http://example.com/article.html',
          'lead_image_url' => 'http://example.com/lead_image_url.jpeg',
          'title' => 'article title',
          'excerpt' => 'article excerpt',
          'word_count' => 10
        }
      end

      it { should have_link }
      its(:type) { should == 'article_with_image' }

      its(:url) { should == 'http://example.com/article.html' }
      its(:image) { should == 'http://example.com/lead_image_url.jpeg' }
      its(:title) { should == 'article title' }
      its(:excerpt) { should == 'article excerpt' }
    end

    context 'to article without lead image url' do
      let(:parsed_content) do
        {
          'url' => 'http://example.com/article.html',
          'lead_image_url' => '',
          'title' => 'article title',
          'excerpt' => 'article excerpt',
          'word_count' => 10
        }
      end

      it { should have_link }
      its(:type) { should == 'article_without_image' }

      its(:url) { should == 'http://example.com/article.html' }
      its(:image) { should be_nil }
      its(:title) { should == 'article title' }
      its(:excerpt) { should == 'article excerpt' }
    end

    context 'to article with image and without text' do
      let(:parsed_content) do
        {
          'url' => 'http://example.com/article.html',
          'excerpt' => '',
          'word_count' =>0,
          'lead_image_url' => 'http://example.com/lead_image_url.jpeg',
          'title' => 'Title with link. http://example.com'
        }
      end

      it { should have_link }
      its(:type) { should == 'image' }
      its(:image) { should == 'http://example.com/lead_image_url.jpeg' }
      its(:title) { should == 'Title with link.' }
    end
  end
end