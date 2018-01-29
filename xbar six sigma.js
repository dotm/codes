function sum(array){
  return array.reduce(function (a, b) { return a + b; }
}

function count(array){
  return array.length
}

function mean_average(array){
  return sum(array) / count(array)
}

function standardDeviation_ofSample(array){
  var average = mean_average(array)
  var distance_fromMean_ofEachArrayElement = array.map(function(element){return element - average})
  var distance_fromMean_ofEachArrayElement_squared = distance_fromMean_ofEachArrayElement.map(function(element){return Math.pow(element,2)})
  
  var sum_ofDistance_fromMean_squared = sum(distance_fromMean_ofEachArrayElement_squared)
  var standardDeviation = Math.sqrt( sum_ofDistance_fromMean_squared / (count(array) - 1) )
  
  return standardDeviation
}

Array.prototype.getSigma = function(sigma){
  var array = this
  var average = mean_average(array)
  var standardDeviation = standardDeviation_ofSample(array)
  
  return average + (sigma * standardDeviation)
}

//-----------------------
// Contoh penggunaan getSigma
function insert_newData_toKpiLibrary(newData){ // fungsi Mas Feri untuk update ke DB
  var kpiData = [63, 60, 72, 64, 65, 68, 66, 65, 67, 64]
  var upper_control_limit = 3 //sigma
  var lower_control_limit = -3 //sigma
  
  if(newData < kpiData.getSigma(lower_control_limit)){
    alert('Trigger Alert API: low kpi data value (below LCL)') // fungsi Alert API Mas Firman
  }else if(newData < kpiData.getSigma(-1)){
    alert('Trigger Alert API: low kpi data value (below -1 sigma)')
  }else if(newData > kpiData.getSigma(upper_control_limit)){
    alert('Trigger Alert API: high kpi data value (above UCL)')
  }
  
  // remove oldest element of kpiData
  kpiData.shift()
  // add newData to kpiData
  kpiData.push(newData)
}