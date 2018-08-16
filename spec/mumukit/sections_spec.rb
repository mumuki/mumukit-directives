require_relative '../spec_helper'

describe 'sections' do
  let(:s) { Mumukit::Directives::Sections.new }

  it { expect(s.split_sections 'foo').to eq({}) }
  it { expect(s.split_sections 'foo /*<baz#*/lalala/*#baz>*/').to eq 'baz' => 'lalala' }
  it { expect(s.split_sections 'foo /*<baz#*/lalala/*#baz>*/ ignored /*<bar#*/lelele/*#bar>*/').to eq 'baz' => 'lalala', 'bar' => 'lelele' }

  it { expect(s.transform('foo' => 'bar',
                          'baz' => 'foobar')).to eq 'foo' => 'bar',
                                                      'baz' => 'foobar' }

  context 'not preserving key' do
    it { expect(s.transform('foo' => 'bar',
                            'foobar' => 'foo /*<baz#*/lalala/*#baz>*/ ignored /*<bar#*/lelele/*#bar>*/')).to eq 'foo' => 'bar',
                                                                                                                'baz' => 'lalala',
                                                                                                                'bar' => 'lelele' }
  end

  context 'preserving parent key' do
    let(:s) { Mumukit::Directives::Sections.new preserve_parent_key: true }

    it { expect(s.transform('foo' => 'bar',
                            'foobar' => 'foo /*<baz#*/lalala/*#baz>*/ ignored /*<bar#*/lelele/*#bar>*/')).to eq 'foo' => 'bar',
                                                                                                                'baz' => 'lalala',
                                                                                                                'bar' => 'lelele',
                                                                                                                'foobar' => {
                                                                                                                    'baz' => 'lalala',
                                                                                                                    'bar' => 'lelele'
                                                                                                                } }
  end
end
