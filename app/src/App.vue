<template>
  <div id="app">
    <Radiogram :cc="callsign" @send="addRadiogram($event)" />
    <CallsignDialog ref="callsignDialog" @callsign="setCallsign" />
    <md-button @click="openCallsignDialog" class="md-primary md-raised">Open</md-button>
    <md-list>
      <md-list-item v-for="msg in messages" :key="msg.id">
        <span>{{msg.number}}</span>
      </md-list-item>
    </md-list>
  </div>
</template>

<script>
import CallsignDialog from './components/CallsignDialog.vue'
import Radiogram from './components/Radiogram.vue'
import firebase from 'firebase'
import 'firebase/firestore'

function makeid(length) {
  let result = '';
  let characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let charactersLength = characters.length;
  for ( let i = 0; i < length; i++ ) {
    result += characters.charAt(Math.floor(Math.random() * charactersLength));
  }
  return result;
}

export default {
  name: 'app',
  components: {
    CallsignDialog,
    Radiogram
  },
  created () {
    let firebaseConfig = {
      apiKey: "AIzaSyDHNdU7w2yMj7uceh58X2ek5_ZHGxzTJBY",
      authDomain: "radiogram-io.firebaseapp.com",
      databaseURL: "https://radiogram-io.firebaseio.com",
      projectId: "radiogram-io",
      storageBucket: "",
      messagingSenderId: "1041994268863",
      appId: "1:1041994268863:web:4d31f8c5c6ce342b"
    };

    try {
      firebase.initializeApp(firebaseConfig);
    } catch (e) {
      console.log('Already inited!');
    }

    this.db = firebase.firestore()
  },
  data () {
    return {
      callsign: 'KM4FPA',
      callsignDialogOpened: false,
      snapshotListener: false,
      messages: [],
      count: 0
    }
  },
  mounted () {
    this.getMessages()
  },
  methods: {
    openCallsignDialog() {
      this.$refs['callsignDialog'].open()
    },
    setCallsign (callsign) {
      this.callsign = callsign
      this.getMessages()
    },
    getMessages () {
      let ref = this.db.collection('testing').doc(this.callsign).collection('2019')
      ref.get().then(snapshot => {
        let messages = []
        snapshot.forEach(doc => messages.push(doc.data()))
        this.messages = messages
      })
    },
    addRadiogram(radiogram) {
      let docId = makeid(7)
      let stationRef =  this.db.collection('testing').doc(this.callsign)
      let docRef = stationRef.collection('2019').doc(docId)
      docRef.set(radiogram).then(() => {
        this.getMessages()
      })
      .catch((error) => {
          console.error("Error writing document: ", error);
      });
    }
  }
}
</script>

<style>
#app {
  font-family: 'Roboto', sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
</style>
