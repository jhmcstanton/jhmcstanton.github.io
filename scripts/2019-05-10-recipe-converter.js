const parentTable = document.getElementsByTagName('table')[0];
const dmeField = 0;
const lmeField = dmeField + 1;

const dmeTable = document.getElementsByTagName('table')[1];
const lmeTable = document.getElementsByTagName('table')[2];

const numField = function(id) {
    return parseInt(document.getElementById(id).value);
}
const efficiency = function() {
    return numField('efficiency');
};

const batchSize = function() {
    return numField('batchSize');
};

const extractWeight = function(field) {
    const weightNode = parentTable.getElementsByTagName('input')[field];
    if ( weightNode.value === '' ) {
        return 0;
    }
    return parseFloat(weightNode.value);
}

const sg = function(field, percent) {
    const weight = extractWeight(field);
    const sg = weight * 45 * percent / batchSize();
    /* Yikes, side effects in a getter. If anyone is reading this, please don't
     * do this and don't judge me :(
     * OTOH, while we're in here lets just display the calculated sg
     */
	const weightNode = parentTable.getElementsByTagName('input')[field];
    weightNode.parentNode.nextSibling.nextSibling.innerHTML = (sg / 1000) + 1;
    return sg;	
};

const setGrainAmounts = function(table, extractWeight, sg) {
    const rows = Array.from(table.getElementsByTagName('tr')).slice(1);
	console.log('confused');
	rows.forEach(function(row) {
			setGrainAmount(row, extractWeight, sg);
	});
}

const setGrainAmount = function(row, extractWeight, sg) {
	const childValStr = row.childNodes[3].childNodes[0].value;
	if (childValStr === '') {
			return;
	}
	const childVal = parseInt(childValStr);
	const grainWeight = childVal * extractWeight * sg / (sg * efficiency());
	row.childNodes[5].innerHTML = grainWeight;
}

const updateAll = function() {
    const dmeSg = sg(dmeField, 1);
    const lmeSg = sg(lmeField, 0.8);
	setGrainAmounts(dmeTable, extractWeight(dmeField), dmeSg);
	setGrainAmounts(lmeTable, extractWeight(lmeField), lmeSg);
}

Array.from(document.getElementsByTagName('input')).forEach(function(input) {
    input.addEventListener('input', updateAll);
})
