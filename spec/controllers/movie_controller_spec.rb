require 'spec_helper'

describe MoviesController do
  describe 'finding similar movies' do
    context 'with valid movie id and similar movies' do
      it 'should make the list of similar movies to the selected movie available to the "Similar To" template' do   
        movie = mock('Movie')
        similar_movies = [ mock('Similar Movie'), mock('Similar Movie')]
        movie.should_receive(:similar_movies).and_return(similar_movies)
        Movie.should_receive(:find).with('1').and_return(movie)
        get :similar_to, { :id => 1 }
        response.should render_template('similar_to')        
        assigns(:movie).should == movie
        assigns(:similar_movies).should == similar_movies
      end
    end
    context 'with valid movie id and no director set' do
      it 'should redirect to the home page and add a warning that no director set' do
        movie = mock('Movie', :title => 'Alien')
        movie.should_receive(:similar_movies).and_raise(Movie::NoSimilarMovies.new("mock message"))
        Movie.should_receive(:find).with('1').and_return(movie)
        get :similar_to, { :id => 1}
        flash[:warning].should match /'Alien' has mock message/
        response.should redirect_to("/movies")
      end
    end
    context 'with invalid movie id' do
      it 'should redirect to the home page and add a warning that movie invalid' do
        Movie.should_receive(:find).with('999').and_raise(ActiveRecord::RecordNotFound)
        get :similar_to, { :id => 999}
        flash[:warning].should match /Movie not found/
        response.should redirect_to("/movies")
      end
    end
  end
 end