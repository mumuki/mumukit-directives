require_relative '../spec_helper'

describe 'sections' do
  let(:s) { Mumukit::Directives::Sections.new }

  it { expect(s.split_sections 'foo').to eq({}) }
  it { expect(s.split_sections 'foo /*<baz#*/lalala/*#baz>*/').to eq 'baz' => 'lalala' }
  it { expect(s.split_sections 'foo /*<baz#*/lalala/*#baz>*/ ignored /*<bar#*/lelele/*#bar>*/').to eq 'baz' => 'lalala', 'bar' => 'lelele' }

  it { expect(s.transform('foo' => 'bar',
                          'baz' => 'foobar')).to eq 'foo' => 'bar',
                                                    'baz' => 'foobar' }

  context 'not nesting sections' do
    it { expect(s.transform('foo' => 'bar',
                            'foobar' => 'foo /*<baz#*/lalala/*#baz>*/ ignored /*<bar#*/lelele/*#bar>*/')).to eq 'foo' => 'bar',
                                                                                                                'baz' => 'lalala',
                                                                                                                'bar' => 'lelele' }
  end

  context 'nesting sections' do
    let(:s) { Mumukit::Directives::Sections.new nest_sections: true }

    it { expect(s.transform('foo' => 'bar',
                            'foobar' => 'foo /*<baz#*/lalala/*#baz>*/ ignored /*<bar#*/lelele/*#bar>*/')).to eq 'foo' => 'bar',
                                                                                                                'foobar' => {
                                                                                                                    'baz' => 'lalala',
                                                                                                                    'bar' => 'lelele'
                                                                                                                } }
  end

  context 'join' do
    it { expect(s.join('foo' => 'bar',
                       'bar' => 'baz',
                       'baz' => 'foo')).to eq "/*<foo#*/bar/*#foo>*/\n/*<bar#*/baz/*#bar>*/\n/*<baz#*/foo/*#baz>*/" }
  end

end
