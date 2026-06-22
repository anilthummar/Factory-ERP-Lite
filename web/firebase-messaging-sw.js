importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
 apiKey: "AIzaSyC59wZRnDFxQmMpEsEQt71Eay60V-n5lX4",
  authDomain: "brainvire-structure.firebaseapp.com",
  projectId: "brainvire-structure",
  storageBucket: "brainvire-structure.appspot.com",
  messagingSenderId: "233913945264",
  appId: "1:233913945264:web:fd8e44a8f5d9e56551ff75",
  measurementId: "G-55VHN508MV"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});
