const AWS = require('aws-sdk');
const DynamoDB = new AWS.DynamoDB({apiVersion: '2012-08-10'});

var params = {
    TableName: process.env.TABLE_NAME,
};

exports.handler =  function(event, context, callback) {
    DynamoDB.scan(params, (err, data) => {
        if (err) {
            callback(err, {
                'statusCode': 500,
                'headers': {
                    "Content-Type": "application/json",
                    "Access-Control-Allow-Origin":  "*",
                    "Access-Control-Allow-Headers": "*",
                },
                'body': JSON.stringify({'message': 'error while fetching movies'})
            });
        } else {
            let movies = [];
            data.Items.forEach(item => {
                movies.push({
                    id: item.id.S,
                    title: item.title.S,
                    rank: item.rank.S,
                    description: item.description.S,
                    poster: item.poster.S,
                    releaseDate: item.releaseDate.S,
                    rating:  item.rating.S,
                    videos: JSON.parse(item.videos.S),
                    actors: JSON.parse(item.actors.S),
                    similar: JSON.parse(item.similar.S),
                })
            })
            callback(null,{
                'statusCode': 200,
                'headers': {
                    "Content-Type": "application/json",
                    "Access-Control-Allow-Origin":  "*",
                    "Access-Control-Allow-Headers": "*",
                },
                'body': JSON.stringify(movies)
            })
        }
    });
}