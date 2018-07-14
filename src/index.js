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
        member: ss.val().member || [],
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
            room.member = room.member || [];

            db.ref(`room/${uid}`).on('value', ss => {
                const room = ss.val();
                room.uid = uid;
                sendOneRoom(room, app.ports.getRoom);
            });

            sendOneRoom(room, app.ports.getRoomViewData);
        })
        .catch(_ => app.ports.getRoomViewData.send(null));
    });

    // send one room
    const sendOneRoom = (room, sender) => {
        room.member = room.member || [];
        const requireUserList = [room.ownerID, ...room.member];

        Promise.all(requireUserList.map(x => db.ref(`users/${x}`).once('value')))
            .then(xs => {
                const users = xs.reduce((acc, x) => {
                    acc[x.key] = x.val();
                    acc[x.key].uid = x.key;
                    return acc;
                }, {});
                room.owner = users[room.ownerID];
                room.member = room.member.map(x => users[x]);
                sender.send(room);
            });
    };

    // create room
    app.ports.createRoom.subscribe(model => {
        const newRoom = {
            name: model.roomName,
            ownerID: auth.currentUser.uid,
            member: [],
            maxNum: model.maxNum,
            pass: model.pass,
            ruleSet: model.ruleSet
        };

        db.ref('room')
            .push(newRoom)
            .then(x => {
                newRoom.uid = x.key;
                sendOneRoom(newRoom, app.ports.createRoomSuccess);
            });
    });

    // getList request
    const sendRoomList = (ss, sender) => {
        const roomList = [];
        ss.forEach(x => {
            roomList.push(newRoom(x));
        });

        const requireUserList = roomList.reduce((acc, x) => [...acc, x.ownerID,...x.member], [])
            .filter((x, i, arr) => arr.indexOf(x) === i);

        Promise.all(requireUserList.map(x => db.ref(`users/${x}`).once('value')))
            .then(xs => {
                const users = xs.reduce((acc, x) => {
                    acc[x.key] = x.val();
                    acc[x.key].uid = x.key;
                    return acc;
                }, {});

                const rooms = roomList.map(x => {
                    x.owner = users[x.ownerID];
                    x.member = x.member.map(x => users[x]);
                    return x;
                });

                sender.send(rooms);
            });
    }

    // join room
    app.ports.joinRoom.subscribe(room => {
        const uid = room.uid;
        room.uid = null;
        room.member.push(auth.currentUser.uid);
        db.ref(`room/${uid}`).update(room);
    });

    // exit room
    app.ports.exitRoom.subscribe(room => {
        const uid = room.uid;
        room.uid = null;
        room.member = room.member.filter(x => x !== auth.currentUser.uid);
        db.ref(`room/${uid}`).update(room);
    });

    // db update
    db.ref('room').on('value', ss => sendRoomList(ss, app.ports.getRoomList));

};
