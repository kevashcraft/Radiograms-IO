<template>
  <md-dialog :md-active.sync="opened" class="callsign-dialog">
    <md-dialog-title>What's Your Callsign?</md-dialog-title>
    <md-content>
      <form @submit.prevent="close">
        <md-field>
          <label>Callsign</label>
          <md-input v-model="callsign" ref="callsign"></md-input>
        </md-field>
      </form>
    </md-content>
    <md-dialog-actions class="flex-spread">
      <md-button @click="cancel">Cancel</md-button>
      <md-button @click="close" class="md-primary md-raised">Go</md-button>
    </md-dialog-actions>
  </md-dialog>
</template>

<style lang="scss">
.callsign-dialog {
  max-width: 300px;
  max-height: 250px;
  padding: 15px;
}
.flex-spread {
  justify-content: space-between;
}
</style>


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
    cancel () {
      this.$emit('callsign', '')
      this.openen = false
    },
    close () {
      this.$emit('callsign', this.callsign)
      this.opened = false
    }
  }
}
</script>
