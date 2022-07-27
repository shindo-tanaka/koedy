class PostsController < ApplicationController

    #before_action :authenticate_user!, only: [:new, :create]
    def top

    end
    
    def index
        redirect_to :action => "search"

        if params[:search1] == nil
            @posts= []
        elsif params[:search1] == ''
            @posts= Post.all
        elsif params[:search1].present?
            #部分検索
            search1 = params[:search1]
            @posts = Post.where(["family LIKE ? OR size LIKE ? OR price LIKE ?", "%#{search1}%", "%#{search1}%", "%#{search1}%"])
        end


    end

    def search
        @posts = Post.all
        
        if params[:search1].present?
            search1 = params[:search1]
            @posts = Post.where(["family LIKE ? OR size LIKE ? OR price LIKE ?", "%#{search1}%", "%#{search1}%", "%#{search1}%"])
        end

        @search_params = post_search_params  #検索結果の画面で、フォームに検索した値を表示するために、paramsの値をビューで使えるようにする
        @posts = @posts.search(@search_params) #Reservationモデルのsearchを呼び出し、引数としてparamsを渡している。

        if params[:tag_ids].present?
            post_ids = []
            params[:tag_ids].each do |key, value| 
              if value == "1"
                Tag.find_by(name: key).posts.each do |p| 
                  post_ids << p.id
                end
              end
            end
            post_ids = post_ids.uniq
            #キーワードとタグのAND検索
            @posts = @posts.where(id: post_ids) if post_ids.present?
        end


    end


    def new
        @post = Post.new
    end

    def create
        post = Post.new(post_params)

        post.user_id = current_user.id

        if post.save
          redirect_to :action => "search"
        else
          redirect_to :action => "new"
        end
    end

    def edit
        @post = Post.find(params[:id])
    end

    def update
        post = Post.find(params[:id])
        if post.update(post_params)
          redirect_to :action => "search", :id => post.id
        else
          redirect_to :action => "new"
        end
    end

    def destroy
        post = Post.find(params[:id])
        post.destroy
        redirect_to action: :search
    end

    private
    def post_params
        params.require(:post).permit(:family, :name, :size, :price, :m_time, :m_cost, :detail, :address, :image, tag_ids: [])
    end

    def post_search_params
        params.fetch(:search, {}).permit(:family, :size, :price, :m_cost, :m_time)
        #fetch(:search, {})と記述することで、検索フォームに値がない場合はnilを返し、エラーが起こらなくなる
        #ここでの:searchには、フォームから送られてくるparamsの値が入っている
    end
end
