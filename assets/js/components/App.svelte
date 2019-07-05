<script>
  import _ from 'lodash'
  import axios from 'axios'
  import Result from './Result.svelte'

  let startDate = ""
  let initialAmount = undefined
  let assets = []
  let rebalanceFrequency = 'off'

  function addAsset() {
    assets = [...assets, {asset: '', allocation: undefined}]
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


<div>
  <div class="ui container">
    <form class="ui form" on:submit|preventDefault={handleSubmit} >
      <div class="field">
        <label>Start date</label>
        <input type=text name="start-date" placeholder="E.g., 2005-05-05" bind:value={startDate}>
      </div>
      <div class="field">
        <label>Initial amount</label>
        <input type=number name="initial-amount" placeholder="Initial amount" bind:value={initialAmount}>
      </div>
      <div class="field">
        <label>Rebalance frequency</label>
        <select bind:value={rebalanceFrequency}> 
          <option value="off">Off</option>
          <option value="yearly">Yearly</option>
          <option value="monthly">Monthly</option>
        </select>
      </div>
      <table class="ui celled table">
        <thead>
          <tr>
            <th>Asset</th>
            <th>Allocation (%)</th>
          </tr>
        </thead>
        <tbody>
          {#each assets as {asset, allocation}, i}
            <tr>
              <td data-label="Asset"><input type=text name="Asset" bind:value={asset} placeholder="Asset"></td>
              <td>
                <div data-label="Allocation"><input type=number min=1 max=100 name="Allocation" bind:value={allocation}></div>
              </td>
            </tr>
          {/each}
          <tr>
            <td>Total</td>
            <td class={totalAllocationClass}>{totalAllocation}</td>
          </tr>
        </tbody>
      </table>
      <button class="ui button" on:click|preventDefault={addAsset}>Add asset</button>
      <button class="ui button">Test Portfolio</button>
    </form>
    <Result data={data}/> 
  </div>
</div>

<style>
.yellow {background-color: yellow}
.red {background-color: red}
.green {background-color: green}
</style>
