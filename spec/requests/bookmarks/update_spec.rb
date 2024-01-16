#  "let!(:bookmark) { Bookmark.create(title: 'Ruby Yagi') }" will be executed before each “scenario” or “it” blocks, it will only execute once and its return value will be cached (subsequent call to it will always return the same value).

# You can think of let!(:bookmark) { Bookmark.create(title: 'Ruby Yagi') } as a function like this :

# def bookmark
#   Bookmark.create(title: 'Ruby Yagi')
# end


require 'rails_helper'

#justforinfo:- we want to update a bookmark, we would send a PATCH or PUT request to the /bookmarks/:id route
describe 'PUT /bookmarks' do
  # this will create a 'bookmark' method, which return the created bookmark object, 
  # before each scenario is ran
  let!(:bookmark) { Bookmark.create(url: 'https://rubyyagi.com', title: 'Ruby Yagi') }

  scenario 'valid bookmark attributes' do
    # send put request to /bookmarks/:id
    put "/bookmarks/#{bookmark.id}", params: {
      bookmark: {
        url: 'https://fluffy.es',
        title: 'Fluffy'
      }
    }

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
    }

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

# The reload method will ask the bookmark (object) to query the database and get its latest value, instead of using the values stored in memory (which we did it in the let! helper method).