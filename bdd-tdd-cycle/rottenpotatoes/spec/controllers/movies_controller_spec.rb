require 'spec_helper'

describe MoviesController do

	before :each do
		@movie = mock(Movie, :title => "Star Wars", :director => "Ridley Scott", :id => "1")
		Movie.stub!(:find).with("1").and_return(@movie)
	end

	describe 'add director' do

		it 'should call update_attributes and redirect' do
			@movie.stub!(:update_attributes!).and_return(true)
			put :update, {:id => "1", :movie => @movie}
			response.should redirect_to(movie_path(@movie))
		end
	end

	describe 'find movies with same director' do

		it 'should generate routing  for similar movies' do
			{:post => same_director_movie_path(1) }.should
			route_to(:controller => "movies", :action => "same_director", :id => "1")
		end

		it 'should call the model method that finds same movies' do
			movies_mock =  [mock('Movie1'), mock('Movie2')]
			Movie.should_receive(:same_directors).with('Ridley Scott').and_return(movies_mock)
			get :same_director, id: "1"
		end

		it 'should render same_director template' do
			Movie.stub!(:same_directors).with('Ridley Scott').and_return(@movie)
			get :same_director, :id => "1"
			response.should render_template('same_director')
			assigns(:movies).should == @movie                                                # assigns will compare if the controller instance variable fetch @movie
		end
	end

	describe 'there are no movies with same director' do
		before :each do
	      movie=mock(Movie, :title => "Star Wars", :director => nil, :id => "1")
	      Movie.stub!(:find).with("1").and_return(movie)
	    end

		it 'should generate routing  for similar movies' do
			{:post => same_director_movie_path(1) }.should
			route_to(:controller => "movies", :action => "same_director", :id => "1")
		end

		it 'should render index template and generate a flash' do
			get :same_director, :id => "1"
			response.should redirect_to(movies_path)
			flash[:notice].should_not be_blank
		end
	end
end












	# describe "routing to same_director", :type => :routing do
	# 	it "routes /movies/:id/same_director to movies#same_director" do
	# 		expect(:get => "/movies/1/same_director").to route_to(
	# 			:controller => "movies",
	# 			:id => "1",
	# 			:action => "same_director"
	# 			)
	# 	end
	# end

	# describe "GET #same_director" do
	# 	# it "list movies whith the same director" do
	# 	# end

	# 	it "renders the same_director template" do
	# 		get :same_director, id: Factory(:movie)
	# 		expect(response).to render_template("same_director")
	# 	end
	# end


