require_relative '../spec_helper'

describe "pipeline with sections outputs content as a hash" do
  let(:req) { { content: 'foo /*<baz#*/lalala/*#baz>*/' } }
  let(:p) { Mumukit::Directives::Pipeline.new([sections]) }

  context 'keeping section parent keys' do
    let(:sections) { Mumukit::Directives::Sections.new preserve_parent_key: true }
    it { expect(p.transform(req).content).to eq('baz' => 'lalala') }
  end

  context 'not keeping section parent keys' do
    let(:sections) { Mumukit::Directives::Sections.new }
    it { expect(p.transform(req).content).to be nil }
  end
end
