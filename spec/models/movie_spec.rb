require 'spec_helper'

describe Movie do
  describe 'finding similar movies' do
    fixtures :movies
    context 'with movies with same director' do
     it 'should return array of movies with same directory that does not include itself' do
        similar = movies(:star_wars).similar_movies
        similar.length.should == 2
        similar.should include(movies(:thx_1138), movies(:american_grafitti))        
     end
    end
    context 'with movies without same director' do
      it 'should return an empty array' do
        similar = movies(:blade_runner).similar_movies
        similar.should be_empty
      end
    end
    context 'with no director info' do
      it 'should raise a NoSimilarMovies error' do
        lambda { movies(:alien).similar_movies }.should raise_error(Movie::NoSimilarMovies, 'no director info')
      end
    end
  end
end