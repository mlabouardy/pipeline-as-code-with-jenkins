const Expect = require('chai').expect;
const AWSMock = require('aws-sdk-mock');
const AWS = require('aws-sdk');
const FS = require('fs');

let movies = JSON.parse(FS.readFileSync('test/data.json', 'utf8'));

AWSMock.setSDKInstance(AWS);

AWSMock.mock('DynamoDB', 'scan', function (params, callback){
  callback(null, movies);
});

const DynamoDB = new AWS.DynamoDB({apiVersion: '2012-08-10'});

describe('Movies', () => {
  before(() =>  {
    process.env.TABLE_NAME = 'Movies'
  })
  
  it('should get movies', () => {
    let params = {
        TableName: process.env.TABLE_NAME,
    }

    DynamoDB.scan(params, (err, data) => {
      Expect(data.length).to.equal(1)
      Expect(err).to.equal(null)
    });
  })
})