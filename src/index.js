'use struct'

import './index.html';
import 'bulma/css/bulma.css';
import 'spinkit/css/spinners/2-double-bounce.css';
import './style.css';

import { Main } from './Elm/Main.elm';

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
const providers = {
    Twitter: new firebase.auth.TwitterAuthProvider(),
    Google: new firebase.auth.GoogleAuthProvider(),
    GitHub: new firebase.auth.GithubAuthProvider()
};
auth.languageCode = 'jp';
auth.getRedirectResult();
auth.onAuthStateChanged(user => {
    const app = Main.fullscreen(user ? createUser(user) : null);
    elmInit(app);
});

// Creater
const createUser = user => {
    const userData = {
        uid: user.uid,
        name: user.displayName,
        iconUrl: user.photoURL || null
    };
    db.ref(`users/${user.uid}`).set({ name: userData.name, iconUrl: userData.iconUrl });
    return userData;
};

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

// ElmInit
const elmInit = app => {

    // login request
    app.ports.login.subscribe(type => {
        if (!auth.currentUser) {
            auth.signInWithRedirect(providers[type]);
        }
    });

    // logout request
    app.ports.logout.subscribe(_ => {
        if (auth.currentUser) {
            auth.signOut().then(_ => app.ports.logoutSuccess.send(null));
        }
    });

    // roomListingInit
    app.ports.roomListInit.subscribe(_ => {
        db.ref('room').once('value').then(ss => {
            const roomList = [];
            ss.forEach(x => {
                roomList.push(newRoom(x));
            });
            return roomList;
        }).then(list => {
            db.ref('users').once('value').then(ss => {
                const userList = [];
                ss.forEach(x => {
                    const user = x.val();
                    user.uid = x.key;
                    userList.push(user);
                });

                app.ports.getRoomListDate.send({
                    listValue: list,
                    userList: userList
                });
            });
        });
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
    const sendRoomList = ss => {
        const roomList = [];
        ss.forEach(x => {
            roomList.push(newRoom(x));
        });
        app.ports.getRoomList.send(roomList);
    }

    db.ref('room').on('value', ss => sendRoomList(ss));
};