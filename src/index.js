'use struct'

import './index.html';
import 'bulma/css/bulma.css';

// firebase setting
import firebase from 'firebase/app';
import 'firebase/auth';
import 'firebase/database';
firebase.initializeApp({
    apiKey: API_KEY,
    authDomain: AUTH_DOMAIN,
    databaseURL: DATABASE_URL,
    projectId: PROJECT_ID,
    storageBucket: STORAGE_BUCKET,
    messagingSenderId: MESSAGING_SENDER_ID
});

const auth = firebase.auth();
const db = firebase.database();
const provider = new firebase.auth.TwitterAuthProvider();
auth.languageCode = 'jp';
auth.getRedirectResult();
auth.onAuthStateChanged(user => {
    app.ports.authStateCheck.send(null);
    if (user) {
        const userData = {
            uid : user.uid,
            name : user.displayName,
            iconUrl : user.photoURL
        };
        app.ports.loginSuccess.send(userData);
        db.ref(`users/${user.uid}`).set({ name : userData.name, iconUrl : userData.iconUrl });
    }
});

// Elm Embed
import { Main } from './Elm/Main.elm';
const app = Main.fullscreen();

app.ports.login.subscribe(_ => {
    if (!auth.currentUser) auth.signInWithRedirect(provider);
});

app.ports.logout.subscribe(_ => {
    if (auth.currentUser) auth.signOut().then(x => app.ports.logoutSuccess.send(null));
});

app.ports.createRoom.subscribe(model => {
    const newRoom = {
        name : model.roomName,
        ownerID : auth.currentUser.uid,
        member : [auth.currentUser.uid],
        maxNum : model.maxNum,
        pass : model.pass
    };

    db.ref('room').push(newRoom);
});

// bulma triggers
