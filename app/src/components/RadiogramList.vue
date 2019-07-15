<template>
  <md-content class="radiogram-list-page">
    <div class="radiograms-title">
      <h3>{{callsign }} {{ year }} Radiograms</h3>
    </div>
    <md-list>
      <md-list-item v-for="rg in radiograms" :key="rg.id" class="radiogram-list-item">
        <p class="radiogram-preview md-list-item-text">
          <span>
            <span>#{{rg.number}}</span>
            <span>-</span>
            <span>{{rg.precedence}}</span>
            <span>-</span>
            <span>{{rg.hx}}</span>
            <span>-</span>
            <span>{{rg.destination}}</span>
            <span>-</span>
            <span>{{rg.check}}</span>
            <span>-</span>
            <span>{{rg.dateFiled}}</span>
          </span>
          <span class="radiogram-message">{{rg.message}}</span>
        </p>
        <md-button @click="copy(rg)" class="md-list-action">
          <md-icon>merge_type</md-icon>
        </md-button>
      </md-list-item>
    </md-list>
    <div class="button-div">
      <md-button :href="downloadLink" download="fileee.csv" class="md-raised md-accent">
        <div class="icon-button">
          <md-icon>file_copy</md-icon>
          <span>Download All</span>
        </div>
      </md-button>
    </div>
  </md-content>
</template>

<style lang="scss">
.radiogram-list-page {
  max-width: 100%;
}
.radiograms-title {
  h3 {
    text-align: left;
    margin: 25px;
  }
}
.radiogram-list-item {
  border-top: 1px solid rgba(0, 0, 0, .1);
}
.button-div {
  text-align: left;
}
.radiogram-preview {
  span {
    margin: 0 5px;
  }
}
.radiogram-message {
  margin: 3px 20px !important;
}
</style>


<script>
import moment from 'moment'

export default {
  name: 'RadiogramList',
  props: {
    callsign: String,
    radiograms: Array
  },
  computed: {
    downloadLink () {
      let header = [ 'Number', 'Precedence', 'HX', 'Station of Origin',
                    'Check', 'Place of Origin', 'Time Filed', 'Date Filed',
                    'Destination', 'D. Phone', 'D. Email', 'Message' ]

      const keys = [ 'number', 'precedence', 'hx', 'stationOfOrigin',
                  'check', 'placeOfOrigin', 'timeFiled', 'dateFiled',
                  'destination', 'destinationPhone', 'destinationEmail', 'message']

      var csv = header.join(',') + '\n'

      this.radiograms.forEach(radiogram => {
        var row = []
        keys.forEach(k => {
          row.push(k in radiogram ? radiogram[k] : '')
        })
        csv += row.join(',') + '\n'
      })

      return 'data:text/csv;charset=utf-8,' + encodeURI(csv);
    },

    year () {
      return moment().format('YYYY')
    }
  },
  methods: {
    copy (radiogram) {
      this.$emit('radiogram', radiogram)
    }
  }
}
</script>
