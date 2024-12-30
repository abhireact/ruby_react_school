require 'swagger_helper'

RSpec.describe 'Articles API', type: :request do
  path '/articles' do
    get 'Retrieves all articles' do
      tags 'Articles'
      produces 'application/json'
      
      response '200', 'articles retrieved' do
        schema type: :array, items: { type: :object, properties: { id: { type: :integer }, title: { type: :string }, body: { type: :string } } }

        run_test!
      end
    end
  end
end
