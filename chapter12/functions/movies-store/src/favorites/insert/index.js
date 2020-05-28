const AWS = require('aws-sdk');
const DynamoDB = new AWS.DynamoDB({apiVersion: '2012-08-10'});

exports.handler =  function(event, context, callback) {
    let movie = JSON.parse(event.body);

    var params = {
        TableName: process.env.TABLE_NAME,
        Item: {
            "id": {
              S: movie.id
            }, 
            "title": {
                S: movie.title
            },
            "rank": {
                S: movie.rank
            },
            "rating": {
                S: movie.rating
            },
            "description": {
                S: movie.description
            },
            "poster": {
                S: movie.poster
            },
            "releaseDate": {
                S: movie.releaseDate
            },
            "actors": {
                S: JSON.stringify(movie.actors)
            },
            "videos": {
                S: JSON.stringify(movie.videos)
            },
            "similar": {
                S: JSON.stringify(movie.similar)
            },
        }, 
    };

    DynamoDB.putItem(params, (err, data) => {
        if (err) {
            callback(err, {
                'statusCode': 500,
                'headers': {
                    "Content-Type": "application/json",
                    "Access-Control-Allow-Origin":  "*",
                    "Access-Control-Allow-Headers": "*",
                },
                'body': JSON.stringify({'message': 'error while adding to watchlist'})
            });
        } else {
            callback(null,{
                'statusCode': 200,
                'headers': {
                    "Content-Type": "application/json",
                    "Access-Control-Allow-Origin":  "*",
                    "Access-Control-Allow-Headers": "*",
                },
                'body': event.body
            })
        }
    });
}