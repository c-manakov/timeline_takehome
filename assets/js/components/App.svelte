<script>
  import _ from 'lodash'
  import axios from 'axios'
  import Result from './Result.svelte'
  const newAsset = () => ({asset: '', allocation: undefined})

  let startDate = ""
  let initialAmount = undefined
  let assets = [newAsset()]
  let rebalanceFrequency = 'off'


  function addAsset() {
    assets = [...assets, newAsset()]
  }

  let data = {}
  function handleSubmit() {
    const percentages = _(assets)
      .keyBy('asset')
      .mapValues(it => it.allocation)
      .value()
    const postData = {
      date: startDate,
      amount: initialAmount,
      percentages,
      rebalanceFrequency
    }
    axios.post('/api/calculate', postData)
      .then(resp => {
        data = resp.data    
      })
  }

  let totalAllocationClass

  $: totalAllocation = assets.reduce((acc, val) => acc + (val.allocation || 0), 0)
  $: if(totalAllocation == 0) {
    totalAllocationClass = 'white'
  } else if(totalAllocation < 100) {
    totalAllocationClass = 'yellow'
  } else if(totalAllocation == 100) {
    totalAllocationClass = 'green'
  } else {
    totalAllocationClass = 'red'
  }

</script>


<div class="container d-flex-row">
  <div class="form-container">
    <form class="form" on:submit|preventDefault={handleSubmit} >
      <div class="field d-flex-row justify-content-between">
        <label class ="start-date">Start date</label>
        <input class="col-5" type=text name="start-date" placeholder="E.g., 2005-05-05" bind:value={startDate}>
      </div>
      <div class="field d-flex-row justify-content-between">
        <label>Initial amount</label>
        <input class="col-5" type=number name="initial-amount" placeholder="Initial amount" bind:value={initialAmount}>
      </div>
      <div class="field d-flex-row justify-content-between">
        <label>Rebalance frequency</label>
        <select class="col-5" bind:value={rebalanceFrequency}> 
          <option value="off">Off</option>
          <option value="yearly">Yearly</option>
          <option value="monthly">Monthly</option>
        </select>
      </div>
      <table class="celled table">
        <thead>
          <tr>
            <th>Asset</th>
            <th>Allocation (%)</th>
          </tr>
        </thead>
        <tbody>
          {#each assets as {asset, allocation}, i}
            <tr>
              <td align="center" data-label="Asset"><input type=text name="Asset" bind:value={asset} placeholder="Asset"></td>
              <td align="center">
                <div data-label="Allocation"><input type=number min=1 max=100 name="Allocation" bind:value={allocation}></div>
              </td>
            </tr>
          {/each}
        </tbody>
      </table>
      <div class="d-flex-row"> 
        <h3> 
          Total: {totalAllocation}%
        </h3> 
      </div>
      <div class="d-flex-row justify-content-between">
        <div class="button" on:click|preventDefault={addAsset}><span>Add asset</span></div>
        <div class="button" on:click={handleSubmit}><span>Test Portfolio</span></div>
      </div>
    </form>
  </div>
  <Result data={data}/> 
</div>

<style>
table {
  width: 100%;
  margin: 35px 0;
}
td {
  width: 50%;
}
td input {
  width: 82%; 
  margin: 0 auto;
  padding: 5px 15px;
}

</style>
