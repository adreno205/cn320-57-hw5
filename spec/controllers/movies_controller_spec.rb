#Tanakorn Lueangkajonvit 5510613309
#Wutiiphong Athimatichaikul 5410530017

require 'spec_helper'
describe MoviesController do
    
   describe "GET index" do
    it "ok" do
      get :index, sort: 'title'
    end

    it "is still ok" do
      get :index, sort: 'release_date', ratings: {'PG' => 1 }
    end

    it "is bad" do
      get :index, ratings: {'G' => 1 }
    end

    it "is bad again" do
      get :index
    end

    it "is still bad" do
      get :index, ratings: { 'PG' => 1 }
    end
  end
   
   def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
   end    
  
   describe 'show movie detail' do
    it 'should call model method on Movie given movie exist' do
      fake_movie = double('movie', :id => 1)
      Movie.should_receive(:find).and_return(fake_movie)
      get :show, {:id => 1}
    end
   end
   
   describe 'finding movies by same director' do
      before :each do
         @movie_id = 10
	 @founded = [mock('a movie'), mock('another one')]
	 @fake_movie.stub(:director).and_return('fake director')
      end
      it 'should render same_director view' do
	 Movie.stub(:find).and_return(@fake_movie)
	 Movie.stub(:find_all_by_director).and_return(@founded)

	 get :same_director, {:id => @movie_id}
	 response.should render_template 'same_director'
      end
      it 'should return to home page, if no movies founded' do
	 empty_director = double('movie', :director => '').as_null_object
	 Movie.stub(:find).and_return(empty_director)
	 Movie.stub(:find_all_by_director)

	 get :same_director, {:id => @movie_id}
	 response.should redirect_to(movies_path)
      end
      it 'should call Model method to get movies with same director' do
	 Movie.should_receive(:find).with(@movie_id.to_s).and_return(@fake_movie)
 	 Movie.should_receive(:find_all_by_director).and_return(@founded)

	 get :same_director, {:id => @movie_id}
      end
   end
   
   describe 'add director' do
        before :each do
            @m=mock(Movie, :title => "Star Wars", :director => "director", :id => "1")
            Movie.stub!(:find).with("1").and_return(@m)
        end
        it 'should call update_attributes and redirect' do
            @m.stub!(:update_attributes!).and_return(true)
            put :update, {:id => "1", :movie => @m}
            response.should redirect_to(movie_path(@m))
        end
    end   
   
   describe 'delete an existing movie' do
      it 'should render edit movie template' do
	 Movie.stub(:find)
	 get :edit, {:id => 5}
	 response.should render_template 'edit'
      end
      it 'should call a model method to update data' do
	 my_movie = mock('a movie').as_null_object

 	 Movie.should_receive(:find).and_return(my_movie)
	 my_movie.should_receive(:destroy)
 	 delete :destroy, {:id => 1}
      end
      it 'should render show details template' do
      end
   end

    describe 'destroy' do
    it 'should destroy a movie' do
      m = mock(Movie, :id => "10", :title => "blah", :director => nil)
      Movie.stub!(:find).with("10").and_return(m)
      m.should_receive(:destroy)
      delete :destroy, {:id => "10"}
    end
   end

   describe 'create' do
    it 'should create a new movie' do
      MoviesController.stub(:create).and_return(mock('Movie'))
      post :create, {:id => "1"}
    end
   end
  
  
end

