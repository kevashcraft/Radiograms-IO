<template>
  <div id="app">
    <Radiogram @send="confirmRadiogram($event)" ref="radiogram" />
    <md-dialog :md-active.sync="showRadiogramConfirm" class="radiogram-confirm-dialog">
      <md-dialog-title>Confirm Radiogram Transmission</md-dialog-title>
      <md-content>
        <div class="radiogram-preview-header">
          <p>
            <span>{{radiogram.number}}</span>
            <span>-</span>
            <span>{{radiogram.precedence}}</span>
            <span>-</span>
            <span>{{radiogram.hx}}</span>
            <span>-</span>
            <span>{{radiogram.stationOfOrigin}}</span>
            <span>-</span>
            <span>{{radiogram.check}}</span>
            <span>-</span>
            <span v-show="radiogram.placeOfOrigin">{{radiogram.placeOfOrigin}}</span>
            <span v-show="radiogram.placeOfOrigin">-</span>
            <span>{{radiogram.timeFiled}}</span>
            <span>-</span>
            <span>{{radiogram.dateFiled}}</span>
          </p>
        </div>
        <div class="radiogram-preview-text">
          <p>{{radiogram.message}}</p>
        </div>
      </md-content>
      <md-dialog-actions>
        <md-button @click="addRadiogram" class="md-primary md-raised">Send it</md-button>
      </md-dialog-actions>
    </md-dialog>
    <CallsignDialog ref="callsignDialog" @callsign="setCallsign" />
    <md-button @click="openCallsignDialog" class="md-primary md-raised">Open</md-button>
    <md-list>
      <md-list-item v-for="msg in messages" :key="msg.id">
        <span>{{msg.number}}</span>
      </md-list-item>
    </md-list>
    <md-snackbar md-position="center" :md-duration="2500" :md-active.sync="showSnackbar" md-persistent>
      <span>{{ snackbarMessage }}</span>
    </md-snackbar>  </div>
</template>

<script>
import CallsignDialog from './components/CallsignDialog.vue'
import Radiogram from './components/Radiogram.vue'
import firebase from 'firebase'
import 'firebase/firestore'
import moment from 'moment'

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
      count: 0,
      showRadiogramConfirm: false,
      showSnackbar: false,
      snackbarMessage: '',
      radiogram: {}
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
      console.log('master send first');
      // let ref = this.db.collection('testing').doc(this.callsign).collection('2019')
      // ref.get().then(snapshot => {
      //   let messages = []
      //   snapshot.forEach(doc => messages.push(doc.data()))
      //   this.messages = messages
      // })
    },
    confirmRadiogram(radiogram) {
      this.radiogram = this.formatRadiogram(radiogram)
      let snackbar = false

      // ensure number is int
      if (!Number.isInteger(this.radiogram.number) || !(this.radiogram.number > 0)) {
        snackbar = 'Error: Number must be an integer'
        this.$refs['radiogram'].focusInput('number')
      } else if (typeof this.radiogram.precedence !== 'string' || this.radiogram.precedence.length > 8) {
        snackbar = 'Error: Precedence too long'
        this.$refs['radiogram'].focusInput('precedence')
      } else if (typeof this.radiogram.hx !== 'string' || this.radiogram.hx.length > 8) {
        snackbar = 'Error: HX too long'
        this.$refs['radiogram'].focusInput('hx')
      } else if (typeof this.radiogram.stationOfOrigin !== 'string' || this.radiogram.stationOfOrigin.length < 4 || this.radiogram.stationOfOrigin.length > 16) {
        snackbar = 'Error: Station of Origin'
        this.$refs['radiogram'].focusInput('stationOfOrigin')
      } else if (typeof this.radiogram.placeOfOrigin !== 'string' || this.radiogram.placeOfOrigin.length > 32) {
        snackbar = 'Error: Station of Origin'
        this.$refs['radiogram'].focusInput('placeOfOrigin')
      } else if (typeof this.radiogram.dateFiled !== 'string' || this.radiogram.dateFiled.length !== 10) {
        snackbar = 'Error: Date is wrong'
        this.$refs['radiogram'].focusInput('dateFiled')
      } else if (typeof this.radiogram.timeFiled !== 'string' || this.radiogram.timeFiled.length !== 5) {
        snackbar = 'Error: Time is wrong'
        this.$refs['radiogram'].focusInput('timeFiled')
      } else if (typeof this.radiogram.destination !== 'string' || this.radiogram.destination.length < 4 || this.radiogram.destination.length > 2056) {
        snackbar = 'Error: Invalid destination'
        this.$refs['radiogram'].focusInput('destination')
      } else if (typeof this.radiogram.destinationPhone !== 'string' || this.radiogram.destinationPhone.length > 64) {
        snackbar = 'Error: Invalid destination phone'
        this.$refs['radiogram'].focusInput('destinationPhone')
      } else if (typeof this.radiogram.destinationEmail !== 'string' || this.radiogram.destinationEmail.length > 128) {
        snackbar = 'Error: Invalid destination email'
        this.$refs['radiogram'].focusInput('destinationEmail')
      } else if (!Number.isInteger(this.radiogram.check) || this.radiogram.check > 25) {
        snackbar = 'Error: Message too long'
      } else if (typeof this.radiogram.message !== 'string' || this.radiogram.message.length > 2056) {
        snackbar = 'Error: Message too long'
      } else if (this.radiogram.message.length < 5) {
        snackbar = 'Error: Message not long enough'
      }

      if (snackbar === false) {
        this.showRadiogramConfirm = true
      } else {
        this.snackbarMessage = snackbar
        this.showSnackbar = true
      }

    },
    addRadiogram() {
      let radiogram = Object.assign({}, this.radiogram)
      radiogram.timestamp = firebase.firestore.FieldValue.serverTimestamp()
      radiogram.message = radiogram.messageGroups.join(' ')

      let docId = moment().format('YYYY') + '-' + radiogram.number + '-' + makeid(4)

      let stationRef =  this.db.collection('callsigns').doc('KM4FPA')
      let docRef = stationRef.collection('messages').doc(docId)
      docRef.set(radiogram).then(() => {
        this.showRadiogramConfirm = false
        this.snackbarMessage = 'Message sent!'
        this.showSnackbar = true;
        // this.getMessages()
      })
      .catch((error) => {
        this.snackbarMessage = 'Error: ' + error
        this.showSnackbar = true
      });
    },
    formatRadiogram(data) {
      let radiogram = Object.assign({}, data)
      radiogram.check = radiogram.messageGroups.length
      radiogram.message = radiogram.messageGroups.map(m => m.txt).join(' ')
      return radiogram

    },
  }
}
</script>

<style lang="scss">
#app {
  font-family: 'Roboto', sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

.radiogram-preview-header {
  span {
    margin: 0 5px;
  }
}
.radiogram-preview-message {
  margin: 15px;
}
.radiogram-confirm-dialog {
  max-width: 350px !important;
  max-height: 400px !important;
}
</style>
