<template>
  <md-dialog :md-active.sync="opened">
    <md-dialog-title>What's Your Callsign?</md-dialog-title>
    <md-content>
      <form @submit.prevent="close">
        <md-field>
          <label>Callsign</label>
          <md-input v-model="callsign" ref="callsign"></md-input>
        </md-field>
      </form>
    </md-content>
    <md-dialog-actions>
      <md-button @click="close" class="md-primary md-raised">Close</md-button>
    </md-dialog-actions>
  </md-dialog>
</template>

<script>
export default {
  name: 'CallsignDialog',
  data () {
    return {
      callsign: '',
      opened: false
    }
  },
  watch: {
    callsign (val) {
      let upper = val.toUpperCase()
      if (val !== upper) {
        this.callsign = upper
      }
    },
    opened (val) {
      if (val) {
        setTimeout(() => {
          this.$refs['callsign'].$el.focus()
        }, 500)
      }
    }
  },
  methods: {
    open () {
      this.opened = true
    },
    close () {
      this.$emit('callsign', this.callsign)
      this.opened = false
    }
  }
}
</script>
