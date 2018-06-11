'use struct'

import './index.html';
import 'bulma/css/bulma.css';

// firebase setting
import firebase from 'firebase/app';
import 'firebase/auth';
import 'firebase/database';
firebase.initializeApp({
    apiKey: "AIzaSyCIMfO_EchlKsapvKbW77dO6DQiubB9xls",
    authDomain: "fir-tutorial-1c471.firebaseapp.com",
    databaseURL: "https://fir-tutorial-1c471.firebaseio.com",
    projectId: "fir-tutorial-1c471",
    storageBucket: "fir-tutorial-1c471.appspot.com",
    messagingSenderId: "480413349629"
});

const auth = firebase.auth();
const db = firebase.database();
const provider = new firebase.auth.TwitterAuthProvider();
auth.languageCode = 'jp';
auth.getRedirectResult();
auth.onAuthStateChanged(user => {
    if (user) {
        const userData = {
            uid : user.uid,
            name : user.displayName,
            iconUrl : user.photoURL
        };
        app.ports.loginSuccess.send(userData);
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

// bulma triggers