#  "let!(:bookmark) { Bookmark.create(title: 'Ruby Yagi') }" will be executed before each “scenario” or “it” blocks, it will only execute once and its return value will be cached (subsequent call to it will always return the same value).

# You can think of let!(:bookmark) { Bookmark.create(title: 'Ruby Yagi') } as a function like this :

# def bookmark
#   Bookmark.create(title: 'Ruby Yagi')
# end


require 'rails_helper'

#justforinfo:- we want to update a bookmark, we would send a PATCH or PUT request to the /bookmarks/:id route
describe 'PUT /bookmarks' do

    # group scenarios with authenticated user into this context block
    context 'authenticated user' do
  let!(:bookmark) { Bookmark.create(url: 'https://rubyyagi.com', title: 'Ruby Yagi') }


  # this will create a 'bookmark' method, which return the created bookmark object, 
  # before each scenario is ran
  let!(:bookmark) { Bookmark.create(url: 'https://rubyyagi.com', title: 'Ruby Yagi') }

    # create a user before the test scenarios are run
    let!(:user) { User.create(username: 'soulchild', authentication_token: 'abcdef') }

  scenario 'valid bookmark attributes' do
    # send put request to /bookmarks/:id
    put "/bookmarks/#{bookmark.id}", params: {
      bookmark: {
        url: 'https://fluffy.es',
        title: 'Fluffy'
      }
    }, headers: { 'X-Username': user.username, 'X-Token': user.authentication_token }

    # response should have HTTP Status 200 OK
    expect(response.status).to eq(200)

    # response should contain JSON of the updated object
    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:url]).to eq('https://fluffy.es')
    expect(json[:title]).to eq('Fluffy')

    # The bookmark title and url should be updated
    expect(bookmark.reload.title).to eq('Fluffy')
    expect(bookmark.reload.url).to eq('https://fluffy.es')
  end

  scenario 'invalid bookmark attributes' do
    # send put request to /bookmarks/:id
    put "/bookmarks/#{bookmark.id}", params: {
      bookmark: {
        url: '',
        title: 'Fluffy'
      }
    }, headers: { 'X-Username': user.username, 'X-Token': user.authentication_token }

    # response should have HTTP Status 422 Unprocessable entity
    expect(response.status).to eq(422)

    # response should contain error message
    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:url]).to eq(["can't be blank"])

    # The bookmark title and url remain unchanged
    expect(bookmark.reload.title).to eq('Ruby Yagi')
    expect(bookmark.reload.url).to eq('https://rubyyagi.com')
  end
end

    # scenario with unauthenticated user
  context 'unauthenticated user' do
    it 'should return forbidden error' do
      post '/bookmarks', params: {
        bookmark: {
          url: 'https://rubyyagi.com',
          title: 'RubyYagi blog'
        }
      }

      # response should have HTTP Status 403 Forbidden
      expect(response.status).to eq(403)

      #response contains an error message
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:message]).to eq('Invalid User')
    end
  end
end

# The reload method will ask the bookmark (object) to query the database and get its latest value, instead of using the values stored in memory (which we did it in the let! helper method).