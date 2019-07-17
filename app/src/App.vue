<template>
  <div id="app">
    <div id="window">
      <Radiogram :callsign="callsign" @callsignopen="openCallsignDialog" @send="confirmRadiogram($event)" ref="radiogram" />
      <RadiogramList :callsign="callsign" :radiograms="radiograms" @radiogram="copyRadiogram($event)" />
    </div>
    <RadiogramDialog :radiogram="radiogram" @sendit="addRadiogram" ref="radiogramDialog" />
    <CallsignDialog @callsign="setCallsign" ref="callsignDialog" />
    <md-snackbar md-position="center" :md-duration="2500" :md-active.sync="showSnackbar" md-persistent>
      <span>{{ snackbarMessage }}</span>
    </md-snackbar>
  </div>
</template>

<script>
import CallsignDialog from './components/CallsignDialog.vue'
import Radiogram from './components/Radiogram.vue'
import RadiogramDialog from './components/RadiogramDialog.vue'
import RadiogramList from './components/RadiogramList.vue'
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
    Radiogram,
    RadiogramList,
    RadiogramDialog
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
      // console.log('Already inited!');
    }

    this.db = firebase.firestore()

    let callsign = window.localStorage.getItem('callsign')
    if (callsign) this.callsign = callsign
  },
  data () {
    return {
      callsign: '',
      radiogram: {},
      radiograms: [],
      showSnackbar: false,
      snackbarMessage: '',
    }
  },
  mounted () {
    if (this.callsign) this.getRadiograms()
  },
  methods: {
    openCallsignDialog() {
      this.$refs['callsignDialog'].open()
    },
    setCallsign (callsign) {
      this.callsign = callsign
      window.localStorage.setItem('callsign', callsign)
      this.getRadiograms()
    },
    copyRadiogram (radiogram) {
      this.$refs['radiogram'].set(radiogram)
    },
    getRadiograms () {
      if (!this.callsign) return
      let year = parseInt(moment().format('YYYY'))
      let callsignRef = this.db.collection('callsigns').doc(this.callsign)
      let radiogramsRef = callsignRef.collection('radiograms').where('year', '==', year)
      radiogramsRef.get().then(snapshot => {
        let radiograms = []
        snapshot.forEach(doc => radiograms.push(doc.data()))
        this.radiograms = radiograms.sort((a, b) => a.number < b.number ? 1 : -1)
        this.$refs['radiogram'].setNumber(this.radiograms[0].number + 1)
      })
    },
    confirmRadiogram(radiogram) {
      this.radiogram = this.formatRadiogram(radiogram)
      let snackbar = false

      // ensure number is int
      console.log('this.radiogram', this.radiogram);
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
        this.$refs['radiogramDialog'].open()
        this.showRadiogramConfirm = true
      } else {
        this.snackbarMessage = snackbar
        this.showSnackbar = true
      }

    },
    addRadiogram() {
      let radiogram = Object.assign({}, this.radiogram)
      radiogram.timestamp = firebase.firestore.FieldValue.serverTimestamp()

      let docId = moment().format('YYYY') + '-' + radiogram.number + '-' + makeid(4)

      let stationRef =  this.db.collection('callsigns').doc('KM4FPA')
      let docRef = stationRef.collection('radiograms').doc(docId)
      docRef.set(radiogram).then(() => {
        this.radiograms.unshift(radiogram)
        this.$refs['radiogram'].reset(radiogram.number + 1)
        this.showRadiogramConfirm = false
        this.snackbarMessage = 'Message sent!'
        this.showSnackbar = true;
      })
      .catch((error) => {
        this.snackbarMessage = 'Error: ' + error
        this.showSnackbar = true
      });
    },
    formatRadiogram(data) {
      let radiogram = Object.assign({}, data)
      radiogram.year = parseInt(moment().format('YYYY'))
      radiogram.number = parseInt(data.number)
      radiogram.check = radiogram.messageGroups.length
      radiogram.message = radiogram.messageGroups.map(m => m.txt).join(' ')
      radiogram.stationOfOrigin = this.callsign
      delete radiogram.messageGroups

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
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
}

#window {
  position: absolute;
  top: 0;
  right: 0;
  left: 0;
  overflow-x: hidden;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  // border: 1px solid blue;
}
</style>
