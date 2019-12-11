var api = (function () {
  let apiHost = "10.13.37.222";
  let apiBaseUrl = function () {
    return "http://" + apiHost + "/api/v1"; // ! NOT terminated
  };

  let state = {
    power: null, // {power:INT}
    mode: null, // {index:INT, name:STRING, options:OBJ }
  };

  let setHost = function (host) {
    log("setHost(" + host + ")");
    apiHost = host;
  }

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

  let onPowerResponse = function (powerObject) {
    state.power = powerObject;
    // power.toggler.checked = state.power.power == 1;
    powerSwitch.checked = state.power.power == 1;
  };

  let getMode = function () {
    log("getMode()");

    apiGet("/led/mode", onModeResponse);
  };

  let setMode = function (modeIndex) {
    log("setMode(" + modeIndex + ")");

    apiSet("/led/mode", {"index": modeIndex}, onModeResponse);
  };

  let onModeResponse = function (modeObject) {
    state.mode = modeObject;
    // mode.name.text = state.mode.name;
    mainView.currentIndex = state.mode.index
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
          hndlHeaders(xhr);
          break;
        case XMLHttpRequest.LOADING:
          hndlLoading();
          break;
        case XMLHttpRequest.DONE:
          callback(JSON.parse(xhr.responseText));
          hndlDone(xhr);
          break;
      }
    };

    xhr.open("GET", apiBaseUrl() + path);
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
          hndlHeaders(xhr);
          break;
        case XMLHttpRequest.LOADING:
          hndlLoading();
          break;
        case XMLHttpRequest.DONE:
          callback(JSON.parse(xhr.responseText));
          hndlDone(xhr);
          break;
      }
    };

    xhr.open("POST", apiBaseUrl() + path);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.send(JSON.stringify(data));
  };

  let hndlHeaders = function (xhr) {
    // TODO handle 4xx, 5xx, etc
  };
  let hndlLoading = function () {
    control.state = "loading";
  };
  let hndlDone = function (xhr) {
    // log(xhr.response);
    control.state = "ready";
  };

  let log = function (text) {
    console.log("API:" + text);
  };

  /* ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ******/

  return {
    setHost,
    update,
    getPower,
    setPower,
    togglePower,
    getMode,
    setMode,
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
