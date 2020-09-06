# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::GraphqlController do
  after { post '/graphql', headers: headers }

  it 'passes the right context to the schema' do
    expect(SolidusGraphqlApi::Schema).to receive(:execute)
  end
end
