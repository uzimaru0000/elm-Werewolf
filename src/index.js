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
auth.onAuthStateChanged((() => {
    let flag = false;
    return user => {
        if (!flag) {
            const app = Main.fullscreen(user ? createUser(user) : null);
            elmInit(app);
            flag = true;
        }
    }
})());

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
        pass: ss.val().pass,
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
        db.ref('room').once('value').then(ss => sendRoomList(ss, app.ports.getRoomListDate));
    });

    // roomViewInit
    app.ports.roomViewInit.subscribe(uid => {
        db.ref(`room/${uid}`).once('value').then(ss => {
            const room = ss.val();
            room.uid = uid;
            db.ref(`users/${room.ownerID}`).once('value')
                .then(x => {
                    const user = x.val();
                    user.uid = x.key;
                    room.owner = user;
                    app.ports.getRoomViewData.send(room);
                })
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
            .then(x => app.ports.createRoomSuccess.send(x.key));
    });

    // getList request
    const sendRoomList = (ss, sender) => {
        const roomList = [];
        ss.forEach(x => {
            roomList.push(newRoom(x));
        });

        Promise.all(roomList.map(x => db.ref(`users/${x.ownerID}`).once('value')))
            .then(xs => {
                const users = xs.reduce((acc, x) => {
                    acc[x.key] = x.val();
                    return acc;
                }, {});

                const rooms = roomList.map(x => {
                    const owner = users[x.ownerID];
                    owner.uid = x.ownerID;
                    x.owner = owner;
                    return x;
                });

                sender.send(rooms);
            });
    }

    db.ref('room').on('value', ss => sendRoomList(ss, app.ports.getRoomList));

};
