const Express = require('express');
const BodyParser= require('body-parser');
const Cors = require('cors');
const MongoClient = require('mongodb').MongoClient;
const App = Express();

App.use(Cors())
App.use(BodyParser.urlencoded({ extended: true }))
App.use(BodyParser.json())

var db;

MongoClient.connect(process.env.MONGO_URI, {useUnifiedTopology: true}, (err, database) => {
  if (err) return console.log(err)
  db = database.db(process.env.MONGO_DATABASE)
  App.listen(process.env.PORT || 3000, () => {
    console.log('listening on 3000')
  })
})

App.get('/movies', (req, res) => {
    db.collection('movies').find().toArray((err, result) => {
        if (err) 
            return console.log(err)
        res.send(result)
    })
})

App.get('/movies/:name', (req, res) => {
    db.collection('movies').findOne({'$or': [
        {title: new RegExp( `.*${req.params.name}.`, "i")},
        {id: req.params.name},
    ]}, (err, result) => {
        if (err) 
            return console.log(err)
        res.send(result)
    })
})

App.post('/favorites', (req, res) => {
    db.collection('favorites').save(req.body, (err, result) => {
        if (err) 
            return console.log(err)
        res.send({message:'success'})
    })
})

App.get('/favorites', (req, res) => {
    db.collection('favorites').find().toArray((err, result) => {
        if (err) 
            return console.log(err)
        res.send(result)
    })
})