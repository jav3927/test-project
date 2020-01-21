const testFolder = './files/';
const fs = require('fs');
const sql = require('mssql')
const dateFormat = require('dateformat');

module.exports.insertVacantions = function() {	
	sql.connect('mssql://user1:12345@localhost/test').then(function() {
		fs.readdir(testFolder, (err, files) => {
			files.forEach(file => {
				console.log(file);
				
				let jsonData = fs.readFileSync('./files/' + file, "utf8");
				jsonData = processJSON(jsonData);
				
				new sql.Request().query(`exec InsertNewVacancy '${jsonData}'`).then(function(recordset) {
					console.dir(recordset);
				}).catch(function(err) {
					console.dir(err);
				});		
			});
		});
	}).catch(function(err) {
		console.dir(err);
	});
}


function changeDate(time){
	let now = new Date();
	if(/[0-9]/.test(time)){
		let num = parseInt(time.replace(/\D+/g,""));
		let numS = ""+num;
		switch(time[numS.length]){
			case "h":
				now -= num * 1000 * 60 * 60;
				break;
			case "d":
				now -= num  * 1000 * 60 * 60 * 24;
				break;
			case "m":
				now = now.setMonth(now.getMonth() - num);
				break;
		}
	}
	let date = dateFormat(now,"isoDate");
	return date;
}

function processJSON(data){
	data = data.replace(/'/g, "''")
	let obj = JSON.parse(data);
	obj.positions.forEach(element => {
		element.date = changeDate(element.date);
	});
	return JSON.stringify(obj);
}