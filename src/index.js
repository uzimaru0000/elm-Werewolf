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
            uid: user.uid,
            name: user.displayName || "名無しさん",
            iconUrl: user.photoURL || null
        };
        app.ports.loginSuccess.send(userData);
        db.ref(`users/${user.uid}`).set({ name: userData.name, iconUrl: userData.iconUrl });
    }
});

// Elm Embed
import { Main } from './Elm/Main.elm';
const app = Main.fullscreen();

// login request
app.ports.login.subscribe(type => {
    if (!auth.currentUser) {
        switch (type) {
            case 'Twitter':
                auth.signInWithRedirect(provider);
                break;
            case 'Anonymous':
                auth.signInAnonymously();
                break;
        }
    }
});

// logout request
app.ports.logout.subscribe(_ => {
    if (auth.currentUser) {
        // 匿名アカウントの情報を削除
        if (auth.currentUser.isAnonymous) {
            db.ref(`users/${auth.currentUser.uid}`).remove();
            db.ref(`room`)
                .once('value')
                .then(ss => {
                    ss.forEach(x => {
                        if (x.val().ownerID === auth.currentUser.uid) {
                            db.ref(`room/${x.key}`).remove();
                        }
                    });
                });
        }
        auth.signOut().then(_ => app.ports.logoutSuccess.send(null));
    }
});

// create room
app.ports.createRoom.subscribe(model => {

    const newRoom = {
        name: model.roomName,
        ownerID: auth.currentUser.uid,
        member: [auth.currentUser.uid],
        maxNum: model.maxNum,
        pass: model.pass,
        ruleSet: model.ruleSet
    };

    db.ref('room')
        .push(newRoom)
        .then(_ => app.ports.createRoomSuccess.send(null));
});

// getList request
const newRoom = ss => {
    return {
        uid: ss.key,
        name: ss.val().name,
        ownerID: ss.val().ownerID,
        member: ss.val().member,
        maxNum: ss.val().maxNum,
        pass: ss.val().pass || null,
        ruleSet: ss.val().ruleSet
    };
};

const sendRoomList = ss => {
    const roomList = [];
    ss.forEach(x => {
        roomList.push(newRoom(x));
    });
    app.ports.getRoomList.send(roomList);
}

app.ports.listRequest.subscribe(_ => {
    app.ports.loadingStart.send(null);
    db.ref('room').once('value').then(ss => sendRoomList(ss));
});

db.ref('room').on('value', ss => sendRoomList(ss));

app.ports.usersRequest.subscribe(_ => {
    db.ref('users').once('value').then(ss => {
        const userList = [];
        ss.forEach(x => {
            const user = x.val();
            user.uid = x.key;
            user.iconUrl = user.iconUrl || null;
            userList.push(user);
        });
        app.ports.getUsers.send(userList);
    });
});