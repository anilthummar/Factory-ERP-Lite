importScripts("https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyAJt4ZU14eHr_BvVvsmkcaHrOillVLIrLY",
  authDomain: "factory-erp-lite.firebaseapp.com",
  projectId: "factory-erp-lite",
  storageBucket: "factory-erp-lite.firebasestorage.app",
  messagingSenderId: "485649865712",
  appId: "1:485649865712:web:749eb2b28b7dc8b9881b35",
  measurementId: "G-S3SWBBWGV0",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});
