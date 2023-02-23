// Set your own Team ID and details about your authentication key in the three variables below.
// See the repo at https://github.com/thattridentdude/DeviceCheckExample for more information.
var devAccountTeamID = "R4YNWQ2AN7"; // e.g. "R4YNWQ2AN7"
var authKey = "AuthKey_BWK1SMCO7H.p8"; // e.g. "AuthKey_BWK1SMCO7H.p8"
var authKeyID = "BWK1SMCO7H"; // e.g. "BWK1SMCO7H"

var express = require('express');
var jwt = require('jsonwebtoken');
var fs = require('fs');
var parser = require('body-parser');
var https = require('https');
var app = express();
const uuidv4 = require('uuid').v4;

var router = express();
var http = require('http').createServer(app);
var port = 9889;

router.set('view engine', 'ejs');  
router.use(parser.json());
router.use(parser.urlencoded({ extended: false }))

var dcheckProdEndpoint = 'api.devicecheck.apple.com';
var dcheckDevEndpoint = 'api.development.devicecheck.apple.com';
var authCertificate = fs.readFileSync(authKey).toString();

router.post('/querybits', function(req, response) {
  console.log("Querying bits");
  var dcheckToken = req.body.token;

  var token = jwt.sign({}, authCertificate, { algorithm: 'ES256', keyid: authKeyID, issuer: devAccountTeamID});

  var payloadData = {
      'device_token' : dcheckToken,
      'transaction_id': uuidv4(),
      'timestamp': Date.now()
  }
  var postSettings = {
      host: dcheckDevEndpoint, // Change this to dcheckProdEndpoint when you're ready for primetime
      port: '443',
      path: '/v1/query_two_bits',
      method: 'POST',
      headers: {
          'Authorization': 'Bearer '+token
      }
  };
  var postRequest = https.request(postSettings, function(res) {
      res.setEncoding('utf8');

      console.log(res.headers);
      console.log("Status Code: "+res.statusCode);

      var data = "";
      res.on('data', function (chunk) {
        data += chunk;
      });
      res.on('end', function() {
        try {
          var json = JSON.parse(data);
          console.log(json);
          response.send({"status": res.statusCode,
                         "bit0": json.bit0,
                         "bit1": json.bit1,
                         "lastUpdated": json.last_update_time});
        } catch (e) {
          console.log('error');
          console.log(data);
          response.send({"status": res.statusCode});
        }
      });

      res.on('error', function(data) {
        console.log('error');
        console.log(data);
        response.send({"status": res.statusCode});
      });
  });
  postRequest.write(new Buffer.from(JSON.stringify(payloadData)));
  postRequest.end();
});

router.post('/updatebits', function(req, response) {
  var dcheckToken = req.body.token;
  var bit0 = req.body.bit0;
  var bit1 = req.body.bit1;

  console.log("Setting bits to:");
  console.log("bit0: "+bit0);
  console.log("bit1: "+bit1);

  var token = jwt.sign({}, authCertificate, { algorithm: 'ES256', keyid: authKeyID, issuer: devAccountTeamID});

  var payloadData = {
      'device_token' : dcheckToken,
      'transaction_id': uuidv4(),
      'timestamp': Date.now(),
      'bit0': bit0,
      'bit1': bit1
  }
  var postSettings = {
      host: dcheckDevEndpoint, // Change this to dcheckProdEndpoint when you're ready for primetime
      port: '443',
      path: '/v1/update_two_bits',
      method: 'POST',
      headers: {
          'Authorization': 'Bearer '+token
      }
  };
  var postRequest = https.request(postSettings, function(res) {
      res.setEncoding('utf8');

      console.log(res.headers);
      console.log("Status Code: "+res.statusCode);

      var data = "";
      res.on('data', function (chunk) {
        data += chunk;
      });
      res.on('end', function() {
        console.log(data);
        response.send({"status": res.statusCode});
      });

      res.on('error', function(data) {
        console.log('error');
        console.log(data);
        response.send({"status": res.statusCode});
      });
  });
  postRequest.write(new Buffer.from(JSON.stringify(payloadData)));
  postRequest.end();
});

app.use(router);
http.listen(port);
