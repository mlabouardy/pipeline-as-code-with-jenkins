const Expect = require('chai').expect
const MongoUnit = require('mongo-unit')
const DAO = require('../dao')
const TestData = require('./movies.json')

describe('StoreDAO', () => {
  before(() =>  MongoUnit.start().then(() => {
    console.log('fake mongo is started: ', MongoUnit.getUrl())
    process.env.MONGO_URI = MongoUnit.getUrl()
    process.env.MONGO_DATABASE = 'test'
    DAO.init() 
  }))
  beforeEach(() => MongoUnit.load(TestData))
  afterEach(() => MongoUnit.drop())
  after(() => {
    DAO.close()
    return MongoUnit.stop()
  })

 it('should find all movies', () => {
   return DAO.Movie.find()
    .then(movies => {
      Expect(movies.length).to.equal(8)
      Expect(movies[0].title).to.equal('Pulp Fiction (1994)')
    })
 })

 it('should add to favorites', () => {
   let favorite = new DAO.Favorite({
      title: 'John Wick (2014)',
      rating: '7.4/10',
      releaseDate: '24 October 2014 (USA)',
      poster: 'https://m.media-amazon.com/images/M/MV5BMTU2NjA1ODgzMF5BMl5BanBnXkFtZTgwMTM2MTI4MjE@._V1_UX182_CR0,0,182,268_AL_.jpg'
   })
   return favorite.save()
    .then(movie => {
      Expect(movie.title).to.equal('John Wick (2014)')
    })
 })

 it('should find a movie', () => {
   return DAO.Movie.findOne({'$or': [
      {title: new RegExp( `.*Seven Samurai.`, "i")},
   ]})
   .then(movie => {
     Expect(movie.title).to.equal('Seven Samurai (1954)')
     Expect(movie.releaseDate).to.equal('19 November 1956 (USA)')
     Expect(movie.rating).to.equal('8.6/10')
   })
 })
})