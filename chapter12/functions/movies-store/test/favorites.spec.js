const Expect = require('chai').expect;
const AWSMock = require('aws-sdk-mock');
const AWS = require('aws-sdk');
const FS = require('fs');

let movies = JSON.parse(FS.readFileSync('test/data.json', 'utf8'));

AWSMock.setSDKInstance(AWS);

AWSMock.mock('DynamoDB', 'scan', function (params, callback){
  callback(null, movies);
});

AWSMock.mock('DynamoDB', 'putItem', function (params, callback){
    callback(null, movies[0]);
});

const DynamoDB = new AWS.DynamoDB({apiVersion: '2012-08-10'});

describe('Favorites', () => {
  before(() =>  {
    process.env.TABLE_NAME = 'Favorites'
  })
  
  it('should get favorites', () => {
    let params = {
        TableName: process.env.TABLE_NAME,
    }

    DynamoDB.scan(params, (err, data) => {
      Expect(data).to.equal(movies)
      Expect(err).to.equal(null)
    });
  })

  it('should add to favorites', () => {
    let params = {
        TableName: process.env.TABLE_NAME,
        Item: {
            "id": {
              S: '1'
            }, 
            "title": {
                S: 'John Wick'
            },
            "rank": {
                S: '9'
            },
            "rating": {
                S: '7.4/10'
            },
            "description": {
                S: 'An ex-hit-man comes out of retirement to track down the gangsters that killed his dog and took everything from him.'
            },
            "poster": {
                S: 'https://m.media-amazon.com/images/M/MV5BMTU2NjA1ODgzMF5BMl5BanBnXkFtZTgwMTM2MTI4MjE@._V1_UX182_CR0,0,182,268_AL_.jpg'
            },
            "releaseDate": {
                S: '24 October 2014 (USA)'
            },
            "actors": {
                S: '[]'
            },
            "videos": {
                S: '[]'
            },
            "similar": {
                S: '[]'
            },
        }, 
    }

    DynamoDB.putItem(params, (err, data) => {
      Expect(data.title.S).to.equal('John Wick')
      Expect(data.description.S).to.equal('An ex-hit-man comes out of retirement to track down the gangsters that killed his dog and took everything from him.')
      Expect(data.rating.S).to.equal('7.4/10')
      Expect(err).to.equal(null)
    });
  })
})