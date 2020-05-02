const Mongoose = require('mongoose')
 
const movieSchema = new Mongoose.Schema({
  title: String,
  id: String,
  poster: String,
  releaseDate: String,
  rating: String,
  genre: String,
  description: String,
  videos: [String],
  similar: [
    {
        title: String,
        poster: String,
    }
  ],
  actors: [
      {
          picture: String,
          name: String,
          role: String
     }
  ],
  rank: String,
})

module.exports = {
  init: () => Mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }),
  close: () => Mongoose.disconnect(),
  Movie: Mongoose.model('movie', movieSchema),
  Favorite: Mongoose.model('favorite', movieSchema),
}