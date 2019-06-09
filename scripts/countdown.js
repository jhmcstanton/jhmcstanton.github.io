const tz = "America/Chicago";
const clock_base = moment.tz(document.getElementById("clock_base").innerHTML, tz);
const sections = document.getElementsByClassName('clock-section-amount');

const update_clock = function() {
    const now = moment.tz(tz);
    sections[0].innerHTML = Math.abs(clock_base.diff(now, 'months'));
    sections[1].innerHTML = Math.abs(clock_base.diff(now, 'days') % moment(now).daysInMonth());
    sections[2].innerHTML = Math.abs(clock_base.diff(now, 'hours') % 24 );
    sections[3].innerHTML = Math.abs(clock_base.diff(now, 'minutes') % 60);
    sections[4].innerHTML = Math.abs(clock_base.diff(now, 'seconds') % 60);
};
update_clock();
setInterval(update_clock, 1000);

