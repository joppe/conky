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

const DAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
const MONTHS = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

function formatDate(date) {
  if (!date) {
    return '';
  }

  const o = new Date(date);

  return `${DAYS[o.getDay()]} ${MONTHS[o.getMonth()]} ${o.getDate()} ${o
    .getHours()
    .toString()
    .padStart(2, '0')}:${o.getMinutes().toString().padStart(2, '0')}`;
}

function noramilizeEvent(event) {
  return {
    summary: event.summary,
    start: formatDate(event.start.dateTime || event.start.date),
    end: formatDate(event.end.dateTime || event.end.date),
  };
}

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
        console.log(
          JSON.stringify({ events: result.data.items.map(noramilizeEvent) }),
        );
      } else {
        console.warn(JSON.stringify({ message: 'No upcoming events found.' }));
      }
    }
  },
);
