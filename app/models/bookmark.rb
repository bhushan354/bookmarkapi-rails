# use this command to POST to an api when postman gives error

# curl -X POST -H "Content-Type: application/json" -d '{"bookmark": {"title": "Bhushan Deshmukh", "url": "http://Bhushan.com"}}' http://127.0.0.1:3000/bookmarks


class Bookmark < ApplicationRecord
    validates :title, presence: true, allow_blank: false
    validates :url, presence: true, allow_blank: false
end
