(function(d){
    var showXML = function(){
        this.innerText = this.dataset.xmlDate;
    };
    var showFrom = function(){
        this.innerText = this.dataset.fromDate;
    };

    var updateTimes = function(){
        var els = d.getElementsByClassName("time");
        for(var i=0; i<els.length; i++){
            els[i].dataset.xmlDate = els[i].innerText;
            els[i].dataset.fromDate = moment(els[i].innerText).fromNow();
            els[i].innerText = els[i].dataset.fromDate;
            els[i].onmouseover = showXML;
            els[i].onmouseout  = showFrom;
            els[i].onmouseup   = showFrom;
        }
    };

    d.onreadystatechange = function(){
        if(this.readyState === "complete"){
            updateTimes();
        }
    }
})(document);