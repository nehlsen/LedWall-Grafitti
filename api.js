var api = (function () {
  const API_BASE_URL = "http://10.13.37.222/api/v1"; // ! NOT terminated

  let state = {
    power: null, // {power:INT}
    mode: null, // {index:INT, name:STRING, options:OBJ }
  };

  let update = function () {
    getPower();
    getMode();
  };

  let getPower = function () {
    log("getPower()");

    apiGet("/led/power", onPowerResponse);
  };

  let setPower = function (on) {
    log("setPower(" + on + ")");

    apiSet("/led/power", {"power": on ? 1 : 0}, onPowerResponse);
  };

  let togglePower = function () {
    return setPower(state.power.power === 0);
  };

  let getMode = function () {
    log("getMode()");

    apiGet("/led/mode", (responseObject) => {
      state.mode = responseObject;
      mode.name.text = state.mode.name;
    });
  };

  let onPowerResponse = function (powerObject) {
    state.power = powerObject;
    power.toggler.checked = state.power.power == 1;
  };

  /* ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ******/

  let apiGet = function (path, callback) {
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function () {
      // log("req state: " + xhr.readyState);
      switch (xhr.readyState) {
        case XMLHttpRequest.UNSENT:
          break;
        case XMLHttpRequest.OPENED:
          break;
        case XMLHttpRequest.HEADERS_RECEIVED:
          hndlHeaders();
          break;
        case XMLHttpRequest.LOADING:
          hndlLoading();
          break;
        case XMLHttpRequest.DONE:
          log(xhr.response);
          callback(JSON.parse(xhr.responseText));
          hndlDone();
          break;
      }
    };

    xhr.open("GET", API_BASE_URL + path);
    xhr.send();
  };

  let apiSet = function (path, data, callback) {
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function () {
      // log("req state: " + xhr.readyState);
      switch (xhr.readyState) {
        case XMLHttpRequest.UNSENT:
          break;
        case XMLHttpRequest.OPENED:
          break;
        case XMLHttpRequest.HEADERS_RECEIVED:
          hndlHeaders();
          break;
        case XMLHttpRequest.LOADING:
          hndlLoading();
          break;
        case XMLHttpRequest.DONE:
          log(xhr.response);
          callback(JSON.parse(xhr.responseText));
          hndlDone();
          break;
      }
    };

    xhr.open("POST", API_BASE_URL + path);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.send(JSON.stringify(data));
  };

  let hndlHeaders = function () {
    // TODO handle 4xx, 5xx, etc
  };
  let hndlLoading = function () {
    mainLayout.state = "loading";
  };
  let hndlDone = function () {
    mainLayout.state = "ready";
  };

  let log = function (text) {
    console.log("API:" + text);
  };

  /* ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ******/

  return {
    update,
    getPower,
    setPower,
    togglePower,
    getMode
  };
})();

/*
{
    "index":	2,
    "name":	"Hsiboy",
    "options":	{
        "animateSpeed":	255,
        "animation":	9
    }
}
*/

/*
var modeObj;

function log(text) {
    console.log(text);
}

function getMode() {
    log("API:getMode()");

    var xhr = new XMLHttpRequest();

    xhr.onreadystatechange = function() {
        log("req state: " + xhr.readyState);

        switch (xhr.readyState) {
        case XMLHttpRequest.UNSENT:
            break;
        case XMLHttpRequest.OPENED:
            break;
        case XMLHttpRequest.HEADERS_RECEIVED:
            break;
        case XMLHttpRequest.LOADING:
            break;
        case XMLHttpRequest.DONE:
            break;
        }

        if (xhr.readyState === XMLHttpRequest.DONE) {
            log(xhr.response);

            modeObj = JSON.parse(xhr.responseText);
            mode.name.text = modeObj.name;
        }
    };

    xhr.open("GET", "http://10.13.37.222/api/v1/led/mode");
    xhr.send();
}
*/
