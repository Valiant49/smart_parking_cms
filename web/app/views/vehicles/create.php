<form action="/vehicles/store" method="post" class="card max-w-xl space-y-4">
  <div>
    <label class="label">Plate number</label>
    <input class="input" name="plate_number" required>
  </div>
  <div>
    <label class="label">Owner name</label>
    <input class="input" name="owner_name" required>
  </div>
  <div class="grid grid-cols-2 gap-4">
    <div>
      <label class="label">Type</label>
      <select class="input" name="vehicle_type">
        <option>car</option><option>motorcycle</option><option>suv</option><option>van</option><option>truck</option>
      </select>
    </div>
    <div>
      <label class="label">Contact</label>
      <input class="input" name="owner_contact">
    </div>
  </div>
  <div class="flex gap-2">
    <button class="btn btn-primary">Save</button>
    <a href="/vehicles" class="btn btn-secondary">Cancel</a>
  </div>
</form>