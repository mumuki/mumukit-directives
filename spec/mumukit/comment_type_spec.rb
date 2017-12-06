require_relative '../spec_helper'

describe 'comment' do
  let(:comment_type) { Mumukit::Directives::CommentType.parse(type) }

  context 'Haskell' do
    let(:type) { 'haskell' }
    it { expect(comment_type.comment 'comment me').to eq '{-comment me-}' }
  end

  context 'Ruby' do
    let(:type) { 'ruby' }
    it { expect(comment_type.comment 'comment me').to eq '#comment me#' }
  end

  context 'Cpp' do
    let(:type) { 'cpp' }
    it { expect(comment_type.comment 'comment me').to eq '/*comment me*/' }
  end
end