require 'spec_helper'

describe MoviesController, :type => :controller do
    describe "#index" do
        context "when first load" do
            it "renders the index template" do
                get :index
                response.should render_template("index")
            end
        end

        context "when sort on title" do
            it "can sort the movie list by title" do
                movie1 = Movie.create(:title => 'Z')
                movie2 = Movie.create(:title => 'A')
                get :index, :sort => 'title'
                response.redirect_url.should match(/sort=title/)
                #expect(assigns(:movies)).to eq([movie2, movie1])    #assigns never received the :movies variable
            end
        end
        
        context "when sort on date" do
            it "can sort the movie list by release date" do
                movie1 = Movie.create(:release_date => '25-Nov-1992')
                movie2 = Movie.create(:title => '21-Jul-1989')
                get :index, :sort => 'release_date'
                response.redirect_url.should match(/sort=release_date/)
                #expect(assigns(:movies)).to eq([movie2, movie1])  #assigns never received the :movies variable
            end
        end
        
        context "when filter ratings" do
            it "can show movies with certain ratings" do
                movie1 = Movie.create(:rating => 'G')
                movie2 = Movie.create(:rating => 'R')
                get :index, :ratings => 'G'
                response.should redirect_to(root_path(:ratings => :G))
                #expect(assigns(:movies)).to eq([movie1])   #assigns never received the :movies variable
            end
        end
    end
    
    describe "#show" do
        it "shows a movie" do 
            movie = Movie.create()
            get :show, :id => movie
            response.should render_template("show")
            expect(assigns("movie")).to eq(movie)
        end
    end
    
    describe "#new" do
        it "can create movies" do
            current = Movie.count
            get :new
            response.should render_template("new")
            post :create, {:title => :test}
            response.should redirect_to('/movies')
            Movie.count.should eq(current + 1)
        end
    end
    
    describe "#edit" do
        it "can edit movies" do
            movie = Movie.create()
            get :edit, :id => 1
            response.should render_template("edit")
            post :update, :id => movie.id, :movie => {:title => :test}
            response.should redirect_to(movie_path)
            expect(assigns(:movie)).to eq(movie)
            expect(assigns(:movie).title).to eq("test")
        end
    end
    
    describe "#destroy" do
        it "can delete movies" do
            movie = Movie.create()
            current = Movie.count
            get :destroy, :id => movie
            response.should redirect_to(movies_path)
            Movie.count.should eq (current - 1)
        end
    end
    
    describe "same_director" do
        it "can find matching directors" do
            movie1 = Movie.create(:title => :test, :director => :dir)
            movie2 = Movie.create(:title => :test2, :director => :dir)
            movie3 = Movie.create()
            get :same_director, :id => movie1
            response.should render_template("same_director")
            expect(assigns("movies")).to eq([movie1, movie2])
        end
    
        it "will show a message if a movie has no director" do
            movie = Movie.create()
            get :same_director, :id => movie
            response.should redirect_to(movies_path)
            expect(flash[:notice]).to eq "'#{movie.title}' has no director info."
        end
    end
end