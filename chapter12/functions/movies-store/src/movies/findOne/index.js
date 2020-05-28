const AWS = require('aws-sdk');
const DynamoDB = new AWS.DynamoDB({apiVersion: '2012-08-10'});

exports.handler =  function(event, context, callback) {
    let name = event.pathParameters.name;

    var params = {
        TableName: process.env.TABLE_NAME,
        IndexName: 'MovieTitleIndex',
        ExpressionAttributeValues: {
            ':title': {
                'S': name
            }
        },
        FilterExpression: 'contains(title, :title)'
    };

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
            if(data.Count > 0){
                let item = data.Items[0]
                let movie = {
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
                }
                callback(null,{
                    'statusCode': 200,
                    'headers': {
                        "Content-Type": "application/json",
                        "Access-Control-Allow-Origin":  "*",
                        "Access-Control-Allow-Headers": "*",
                    },
                    'body': JSON.stringify(movie)
                })
            } else {
                callback(null,{
                    'statusCode': 404,
                    'headers': {
                        "Content-Type": "application/json",
                        "Access-Control-Allow-Origin":  "*",
                        "Access-Control-Allow-Headers": "*",
                    },
                    'body': JSON.stringify({'message': 'movie not found'})
                })
            }
        }
    });
}