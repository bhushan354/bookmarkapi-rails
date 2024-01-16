require 'rails_helper'

describe 'POST /bookmarks' do
     # 'scenario' is similar to 'it', use which you see fit
    scenario 'cheks for valid bookmark attribute or keys' do
        # send a POST request to /bookmarks, with these parameters
        # The controller will treat them as JSON 
       post '/bookmarks', params: {
        bookmark: {
           url: 'https://bhushan.com',
           title: 'Bhushan Deshmukh'
        }
       }

     # response should have HTTP Status 201 Created
        expect(response.status).to eq(201)

        json = JSON.parse(response.body).deep_symbolize_keys

        # check the value of the returned response hash
        expect(json[:url]).to eq('https://bhushan.com')
        expect(json[:title]).to eq('Bhushan Deshmukh')

        # 1 new bookmark record is created
        expect(Bookmark.count).to eq(1)

        # Optionally, you can check the latest record data
        expect(Bookmark.last.title).to eq('Bhushan Deshmukh')
    end

    scenario 'checks invalid attribute' do
        post '/bookmarks', params: {
            bookmark: {
                url: '',
                title: 'Bhushan Deshmukh'

            }
        }
        # response should have HTTP Status 201 Created
        expect(response.status).to eq(422)

        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:url]).to eq(["can't be blank"])

        # no new bookmark record is created
        expect(Bookmark.count).to eq(0)
    end
end