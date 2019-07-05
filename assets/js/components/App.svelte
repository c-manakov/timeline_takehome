<script>
  export let name

  let startYear = undefined
  let initialAmount = undefined

  let assets = []

  function addAsset() {
    assets = [...assets, {asset: '', allocation: undefined}]
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
    <form class="ui form" onsubmit=>
      <div class="field">
        <label>Start year</label>
        <input type=number name="start-year" placeholder="Start year" bind:value={startYear}>
      </div>
      <div class="field">
        <label>Initial amount</label>
        <input type=number name="initial-amount" placeholder="Initial amount" bind:value={initialAmount}>
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
  </div>
</div>

<style>
.yellow {background-color: yellow}
.red {background-color: red}
.green {background-color: green}
</style>
