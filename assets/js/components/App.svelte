<script>
  export let name

  let startYear = undefined
  let initialAmount = undefined

  let assets = []

</script>


<div>
  <div class="ui container">
    <form class="ui form">
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
              <td data-label="Asset"><input type=text name="Asset" bind:value={asset}></td>
              <td data-label="Allocation"><input type=number name="Allocation" bind:value={allocation}></td>
            </tr>
          {/each}
        </tbody>
      </table>
      <button class="ui button" type="submit">Add asset</button>
      <button class="ui button" type="submit">Test Portfolio</button>
    </form>
  </div>
</div>

<style>
</style>
