<template>
  <md-dialog :md-active.sync="opened" class="radiogram-confirm-dialog">
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
      <md-button @click="send" class="md-primary md-raised">Send it</md-button>
    </md-dialog-actions>
  </md-dialog>
</template>

<style lang="scss" scoped>

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


<script>
export default {
  name: 'RadiogramDialog',
  props: {
    radiogram: Object
  },
  data () {
    return {
      opened: false
    }
  },
  methods: {
    open () {
      this.opened = true
    },
    send () {
      this.$emit('sendit')
      this.opened = false
    }
  },
}
</script>
