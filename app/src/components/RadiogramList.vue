<template>
  <md-content>
    <md-list>
      <md-list-item v-for="rg in radiograms" :key="rg.id">
        <p>
          <span>{{rg.number}}</span>
          <span>-</span>
          <span>{{rg.precedence}}</span>
          <span>-</span>
          <span>{{rg.hx}}</span>
          <span>-</span>
          <span>{{rg.stationOfOrigin}}</span>
          <span>-</span>
          <span>{{rg.check}}</span>
          <span>-</span>
          <span v-show="rg.placeOfOrigin">{{rg.placeOfOrigin}}</span>
          <span v-show="rg.placeOfOrigin">-</span>
          <span>{{rg.timeFiled}}</span>
          <span>-</span>
          <span>{{rg.dateFiled}}</span>
        </p>
      </md-list-item>
    </md-list>
    <div class="button-div">
      <md-button :href="downloadLink" download="fileee.csv">
        <div class="icon-button">
          <md-icon>file_copy</md-icon>
          <span>Download All</span>
        </div>
      </md-button>
    </div>
  </md-content>
</template>

<style lang="scss">
.button-div {
  text-align: left;
}
</style>


<script>
export default {
  name: 'RadiogramList',
  props: {
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
    }
  }
}
</script>
