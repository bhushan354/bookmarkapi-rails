# scaffold (model + controller) 

# rails generate scaffold Bookmark title:string url:string

# Running this command generate the model, controller and prefilled request specs file for the bookmark routes.

class BookmarksController < ApplicationController
  before_action :set_bookmark, only: %i[ show update destroy ]
  before_action :authenticate_user

  # GET /bookmarks
  def index
    @bookmarks = Bookmark.all

    render json: @bookmarks
  end

  # GET /bookmarks/1
  def show
    render json: @bookmark
  end

  # POST /bookmarks
  def create
    @bookmark = Bookmark.new(bookmark_params)

    if @bookmark.save
      render json: @bookmark, status: :created, location: @bookmark
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bookmarks/1
  def update
    if @bookmark.update(bookmark_params)
      render json: @bookmark
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bookmarks/1
  def destroy
    @bookmark.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bookmark_params
      params.require(:bookmark).permit(:title, :url)
    end

    private
      def authenticate_user
      # find the user based on the headers from HTTP request
      @current_user = User.find_by(

        # These lines are attempting to extract information from the HTTP headers of an incoming request. The headers in an HTTP request are key-value pairs that contain 
        username: request.headers['X-Username'],
        
        authentication_token: request.headers['X-Token']
      )

      # return error message with 403 HTTP status if there's no such user
      return render(json: { message: 'Invalid User' }, status: 403) unless @current_user
    end
end
