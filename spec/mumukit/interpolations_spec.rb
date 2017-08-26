require_relative '../spec_helper'

describe 'interpolate' do
  let(:i) { Mumukit::Directives::Interpolations.new('test') }

  it { expect(i.interpolations? '').to be false }
  it { expect(i.interpolations? 'test "foo" {}').to be false }
  it { expect(i.interpolations? 'test "foo" { /* here there is a test */ }').to be false }
  it { expect(i.interpolations? 'test "foo" { /**/ }').to be false }
  it { expect(i.interpolations? 'test "foo" { /*......*/ }').to be false }
  it { expect(i.interpolations? 'test "foo" { /*...foo...*/ }').to be true }


  it { expect(i.interpolate 'foo', {}).to eq ['foo', []] }
  it { expect(i.interpolate 'foo', {'bar' => 'lalala'}).to eq ['foo', []] }
  it { expect(i.interpolate 'foo /*...foo...*/', {'bar' => 'lalala'}).to eq ['foo /*...foo...*/', []] }
  it { expect(i.interpolate 'foo /*...bar...*/', {'bar' => 'lalala'}).to eq ['foo lalala', ['bar']] }
  it { expect(i.interpolate 'foo /*...bar...*/ /*...bar...*/', {'bar' => 'lalala'}).to eq ['foo lalala lalala', ['bar']] }
  it { expect(i.interpolate 'foo /*...foo...*/ /*...bar...*/', {}).to eq ['foo /*...foo...*/ /*...bar...*/', []] }
  it { expect(i.interpolate 'foo /*...baz...*/ /*...bar...*/', {'bar' => 'lalala',
                                                                'baz' => 'lelele'}).to eq ['foo lelele lalala', ['baz', 'bar']] }

  it { expect(i.interpolate 'foo /*...previousContent...*/ /*...bar...*/', lambda { |key| 'lalala' }).to eq ['foo lalala lalala', ['previousContent', 'bar']] }
  it { expect(i.interpolate 'foo /*...previousContent...*/ /*...bar...*/', lambda { |key| 'lalala' if key == 'previousContent' }).to eq ['foo lalala /*...bar...*/', ['previousContent']] }

  it { expect(i.transform('test' => 'baz',
                          'extra' => 'bar',
                          'content' => 'foo')).to eq 'test' => 'baz',
                                                     'extra' => 'bar',
                                                     'content' => 'foo' }

  it { expect(i.transform('test' => '/*...content...*/ baz /*...extra...*/',
                          'extra' => 'bar',
                          'content' => 'foo')).to eq 'test' => 'foo baz bar' }

  it { expect(i.transform('test' => '/*...content...*/ baz',
                          'extra' => 'bar',
                          'content' => 'foo')).to eq 'extra' => 'bar',
                                                     'test' => 'foo baz' }

  it { expect(i.transform('test' => '/*...content...*/ baz /*...extra...*/',
                          'content' => 'foo')).to eq 'test' => 'foo baz /*...extra...*/' }

  it { expect(i.transform('test' => '/*...content...*/ baz /*...extra...*/',
                          'content' => 'foo',
                          'extra' => '')).to eq 'test' => 'foo baz ' }
end
