( function() {
    var url = "ws://" + window.location.href.split("/")[2] + "/robotemp",
        robotemp = document.robotemp = {
            socket: new WebSocket(url),
            span: document.body.querySelector("#robotemp"),
            onmessage: function(event){
                this.span.innerHTML = event.data;
            }
        }

    for (let key in robotemp) {
      if (typeof robotemp[key] == 'function') {
        robotemp[key] = robotemp[key].bind(robotemp);
      }   
    }
    robotemp.socket.onmessage = robotemp.onmessage;
})(); 



