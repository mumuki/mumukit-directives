require_relative '../spec_helper'

describe "pipeline with sections outputs content as a hash" do
  let(:p) { Mumukit::Directives::Pipeline.new([Mumukit::Directives::Sections.new]) }
  let(:req) { {
      content: 'foo /*<baz#*/lalala/*#baz>*/'
  } }

  it { expect(p.transform(req).content).to eq('baz' => 'lalala') }
end