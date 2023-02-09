const fs = require('fs');
const path = require('path');
const { google } = require('googleapis');

const credentialsPath = path.resolve(__dirname, 'credentials.json');
const credentialsFile = fs.readFileSync(credentialsPath);
const credentials = JSON.parse(credentialsFile);

const secretsPath = path.resolve(__dirname, 'secrets.json');
const secretsFile = fs.readFileSync(secretsPath);
const secrets = JSON.parse(secretsFile);

const SCOPES = 'https://www.googleapis.com/auth/calendar.readonly';
const GOOGLE_PRIVATE_KEY = credentials.private_key;
const GOOGLE_CLIENT_EMAIL = credentials.client_email;
const GOOGLE_PROJECT_NUMBER = secrets.project_id;
const GOOGLE_CALENDAR_ID = secrets.calendar_id;

console.log(GOOGLE_PRIVATE_KEY);
console.log(GOOGLE_CLIENT_EMAIL);
console.log(GOOGLE_PROJECT_NUMBER);
console.log(GOOGLE_CALENDAR_ID);

const jwtClient = new google.auth.JWT(
  GOOGLE_CLIENT_EMAIL,
  null,
  GOOGLE_PRIVATE_KEY,
  SCOPES,
);

const calendar = google.calendar({
  version: 'v3',
  project: GOOGLE_PROJECT_NUMBER,
  auth: jwtClient,
});

calendar.events.list(
  {
    calendarId: GOOGLE_CALENDAR_ID,
    timeMin: new Date().toISOString(),
    maxResults: 10,
    singleEvents: true,
    orderBy: 'startTime',
  },
  (error, result) => {
    if (error) {
      res.send(JSON.stringify({ error: error }));
    } else {
      if (result.data.items.length) {
        console.log(JSON.stringify({ events: result.data.items }));
      } else {
        console.warn(JSON.stringify({ message: 'No upcoming events found.' }));
      }
    }
  },
);
