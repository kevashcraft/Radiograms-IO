<template>
  <md-content class="radiogram">
    <form class="md-layout" @submit.prevent="send">
      <div class="form-row">
        <md-field>
          <label>Number</label>
          <md-input v-model="radiogram.number" type="number"></md-input>
        </md-field>
        <md-field>
          <label>Precedence</label>
          <md-input v-model="radiogram.precedence" ></md-input>
        </md-field>
        <md-field>
          <label>[HX]</label>
          <md-input v-model="radiogram.hx" ></md-input>
        </md-field>
        <md-field>
          <label>Station of Origin</label>
          <md-input v-model="callsign" disabled></md-input>
        </md-field>
        <md-field>
          <label>Check</label>
          <md-input :value="check" disabled></md-input>
        </md-field>
        <md-field>
          <label>Place of Origin</label>
          <md-input v-model="radiogram.placeOfOrigin" disabled></md-input>
        </md-field>
        <md-field>
          <label>Time Filed</label>
          <md-input v-model="radiogram.time" type="time"></md-input>
        </md-field>
        <md-field>
          <label>Date Filed</label>
          <md-input v-model="radiogram.date" type="date"></md-input>
        </md-field>
      </div>
      <div class="form-row">
        <md-field>
          <label>Station, Address</label>
          <md-input v-model="radiogram.toStation"></md-input>
        </md-field>
        <md-field>
          <label>Phone</label>
          <md-input v-model="radiogram.toPhone" type="phone"></md-input>
        </md-field>
        <md-field>
          <label>Email</label>
          <md-input v-model="radiogram.toEmail" type="email"></md-input>
        </md-field>
      </div>
      <div class="form-row">
        <md-chips v-model="radiogram.message" md-placeholder="Message" ref="chips"></md-chips>
      </div>
      <div class="form-row">
        <md-button type="submit">Send</md-button>
      </div>
    </form>
  </md-content>
</template>

<style lang="scss" scoped>
.form-row {
  display: flex;
  border: 1px solid orange;
}
</style>


<script>
export default {
  name: 'Radiogram',
  props: {
    cs: String,
  },
  computed: {
    check () {
      return this.radiogram.message.length
    },
  },
  watch: {
    cs (callsign) {
      this.callsign = callsign
    }
  },
  data () {
    return {
      radiogram: {
        message: []
      },
      callsign: ''
    }
  },
  mounted () {
    let inp = this.$refs['chips'].$refs['input'].$el
    this.chipInput = inp
    inp.addEventListener('keyup', event => {
      if (event.keyCode === 32) {
        this.addChip()
      }
    })
  },
  methods: {
    addChip () {
      let chip = this.$refs['chips']._data.inputValue
      this.radiogram.message.push(chip)

      this.$refs['chips']._data.inputValue = ''
    },
    send () {
      this.$emit('send', this.radiogram)
    }
  }
}
</script>
