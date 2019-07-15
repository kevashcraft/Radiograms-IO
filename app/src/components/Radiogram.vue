<template>
  <md-card class="radiogram">
    <md-card-header>
      <h1>RADIOGRAM</h1>
    </md-card-header>
    <md-card-content>
      <form class="md-layout radiogram-form" @submit.prevent="send" ref="form">
        <div class="form-row">
          <md-field class="rg-col col-s1">
            <label>Number</label>
            <md-input v-model="radiogram.number" type="number" ref="number"></md-input>
          </md-field>
          <md-field class="rg-col col-s15">
            <label>Precedence</label>
            <md-input v-model="radiogram.precedence" ref="precedence"></md-input>
          </md-field>
          <md-field class="rg-col col-s05">
            <label>[HX]</label>
            <md-input v-model="radiogram.hx" ref="hx"></md-input>
          </md-field>
          <a @click="openCallsignDialog" class="rg-col col-s15 no-a a-col">
            <md-field class="rg-col col-s2">
              <label>Station of Origin</label>
              <md-input v-model="callsign" disabled style="z-index: -1"></md-input>
            </md-field>
          </a>
          <md-field class="rg-col col-s1">
            <label>Check</label>
            <md-input :value="check" disabled></md-input>
          </md-field>
          <md-field class="rg-col col-s2">
            <label>Place of Origin</label>
            <md-input v-model="radiogram.placeOfOrigin" ref="placeOfOrigin"></md-input>
          </md-field>
          <md-field class="rg-col col-s2">
            <label>Time Filed</label>
            <md-input v-model="radiogram.timeFiled" type="time" ref="timeFiled"></md-input>
          </md-field>
          <md-field class="rg-col col-s2">
            <label>Date Filed</label>
            <md-input v-model="radiogram.dateFiled" type="date" ref="dateFiled"></md-input>
          </md-field>
        </div>
        <div class="form-row">
          <md-field class="rg-col col-s3 no-flex">
            <label class="bold-label">To</label>
            <md-textarea v-model="radiogram.destination" ref="destination"></md-textarea>
          </md-field>
          <div class="form-col">
            <md-field class="rg-col col-s2">
              <label>Phone</label>
              <md-input v-model="radiogram.destinationPhone" type="phone" ref="destinationPhone"></md-input>
            </md-field>
            <md-field class="rg-col col-s2">
              <label>Email</label>
              <md-input v-model="radiogram.destinationEmail" type="email" ref="destinationEmail"></md-input>
            </md-field>
          </div>
          <div style="flex: 1"></div>
        </div>
        <div class="form-row flex-start">
          <md-field v-for="(grp, idx) in radiogram.messageGroups" :key="idx" class="rg-col msg-col">
            <label>{{idx+1}}</label>
            <md-input v-model="grp.txt" @input.native="checkForSpace($event, idx)" :ref="inputRef(idx)"></md-input>
          </md-field>
        </div>
        <div class="form-row flex-center form-actions">
          <md-button type="submit" class="md-primary md-raised">
            <div class="icon-button">
              <span>Send Message</span>
              <md-icon>send</md-icon>
            </div>
          </md-button>
        </div>
      </form>
    </md-card-content>
  </md-card>
</template>

<style lang="scss" scoped>
.radiogram {
  max-width: 950px;
  // overflow-x: hidden;
}
.form-row {
  display: flex;
  flex-wrap: wrap;
  justify-content: stretch;
  margin: 10px 0;
  .md-field {
    flex: 1;
  }
  &.flex-start {
    justify-content: space-around;
  }
}
.form-col {
  // display: flex;
  // flex-direction: column;
  // justify-content: flex-start;
  // align-items: flex-start;
  width: 300px;
  flex: 0;
  @media screen and (max-width: 800px) {
    display: flex;
    flex: 1;
    margin-left: 15px;
  }
}
.radiogram-form {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
}
// .rg-col col-s1 {
//   width: 100px;
// }
.rg-col {
  label {
    top: 0 !important;
    font-size: 12px;
  }
}
.a-col {
  display: inline-block;
  // width: 120px;
}
.msg-col {
  flex: 0 !important;
  input {
    max-width: 150px;
  }
  label {
    opacity: .4;
  }
  @media screen and (max-width: 800px) {
    flex: 1 !important;
    min-width: 25% !important;
    max-width: 30% !important;
  }
}
.col-s05 {
  width: 80px;
  // flex: 0;
  input {
    max-width: 50px;
  }
}
.col-s1 {
  width: 100px;
  input {
    max-width: 65px;
  }
}
.col-s15 {
  width: 150px;
  input {
    max-width: 95px;
  }
}
.col-s2 {
  width: 180px;
  input {
    max-width: 130px;
  }
}
.col-s3 {
  width: 300px;
  input {
    max-width: 250px;
  }
  textarea {
    width: 300px;
    max-width: 300px;
  }
  margin-right: 15px;
}
.msg-col {
  margin: 15px;
}
.bold-label {
  font-weight: bold;
}
.no-flex {
  flex: 0 !important;
}
.md-field {
  margin-bottom: 0 !important;
}
.flex-center {
  justify-content: center;
}
.form-actions {
  margin-top: 65px;
}
</style>


<script>
import moment from 'moment'

export default {
  name: 'Radiogram',
  props: {
    callsign: String,
  },
  computed: {
    check () {
      return this.radiogram.messageGroups.filter(g => g.txt.length > 0).length
    },
  },
  watch: {
    check (populated) {
      let total = this.radiogram.messageGroups.length
      let available = total - populated
      if (available < 10) {
        for (let i=0; i < 5; i++) {
          this.radiogram.messageGroups.push({txt: ''})
        }
      }
    }
  },
  data () {
    return {
      radiogram: {
        number: 1,
        precedence: 'R',
        hx: 'HXG',
        placeOfOrigin: '',
        dateFiled: moment().format('YYYY-MM-DD'),
        timeFiled: moment().format('HH:mm'),
        destination: '',
        destinationEmail: '',
        destinationPhone: '',
        messageGroups: new Array(15).fill().map(() => Object.assign({}, {txt: ''}))
      },
    }
  },
  created () {
    this.radiogramSpec = JSON.stringify(this.radiogram)
  },
  mounted () {
  },
  methods: {
    inputRef (idx) {
      return `input-${idx}`
    },
    checkForSpace(e, idx) {
      if (e.data && e.data === ' ') {
        if (idx < this.radiogram.messageGroups.length - 1) {
          this.$refs[`input-${idx+1}`][0].$el.focus()
        }
      }
    },
    focusInput (input) {
      this.$refs['form'].scrollIntoView()
      this.$refs[input].$el.focus()
    },
    preventSpace (event) {
      if (event.keyCode && event.keyCode === 32) {
        event.preventDefault()
      }
    },
    openCallsignDialog () {
      this.$emit('callsignopen')
    },
    setNumber (n) {
      this.radiogram.number = n
    },
    send () {
      this.$emit('send', this.radiogram)
    },
    set (radiogram) {
      this.radiogram.hx = radiogram.hx
      this.radiogram.precedence = radiogram.precedence
      this.radiogram.placeOfOrigin = radiogram.placeOfOrigin
      this.radiogram.destination = radiogram.destination
      this.radiogram.destinationPhone = radiogram.destinationPhone
      this.radiogram.destinationEmail = radiogram.destinationEmail
      this.radiogram.messageGroups = radiogram.message.split(' ').map(txt => Object.assign({}, {txt}))
    },
    reset (n) {
      let radiogram = JSON.parse(this.radiogramSpec)
      radiogram.number = n
      this.radiogram = radiogram
    }
  }
}
</script>
