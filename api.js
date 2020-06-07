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
    getPower(() => {
      getModes(() => {
        getMode();
      });
    });
  };

  let getPower = function (fnAfter) {
    log("getPower()");

    apiGet("/led/power", (responseObject) => { onPowerResponse(responseObject); if (fnAfter) fnAfter(); });
  };

  let setPower = function (isOn) {
    log("setPower(" + isOn + ")");

    apiSet("/led/power", {"power": isOn ? 1 : 0}, onPowerResponse);
  };

  let togglePower = function () {
    return setPower(state.power.power === 0);
  };

  let onPowerResponse = function (powerObject) {
    state.power = powerObject;
    // power.toggler.checked = state.power.power == 1;
    powerSwitch.checked = state.power.power == 1;
  };

  let getModes = function (fnAfter) {
    log("getModes()");

    apiGet("/led/modes", (responseObject) => { onModesResponse(responseObject); if (fnAfter) fnAfter(); });
  };

  let onModesResponse = function (modesObject) {
    log("onModesResponse(" /*+ JSON.stringify(modesObject)*/ + ")");
// {"modes":[{"index":0,"name":"Status"},{"index":1,"name":"Bars"},{"index":2,"name":"MultiBars"},{"index":3,"name":"Fireworks"},{"index":4,"name":"Sample"},{"index":5,"name":"Hsiboy"},{"index":6,"name":"Fire"},{"index":7,"name":"Camera"},{"index":8,"name":"Network"},{"index":9,"name":"Breathe"},{"index":10,"name":"Text"}]}

      // clear swipe view
    while (mainView.count > 0) {
      mainView.takeItem(0).destroy();
    }

    let finishCreation = (qmlComponent, mode) => {
      console.log("=> finishCreation (" + mode.name + ")...");
      qmlComponent.createObject(mainView, {
        api: api,
        modeName: mode.name,
        modeOptions: mode.options
      });
    };

    modesObject.modes.forEach(mode => {
//      console.log("=> create pane for " + JSON.stringify(mode));
      Qt.createComponent("qrc:/ModeOptions/ModeOptionsPane.qml");
      var qmlComponent;
      switch (mode.name) {
        case "Status":
//          Qt.createComponent("qrc:/ModeOptions/ModeOptionsStatus.qml").createObject(mainView, {modeName: "Status"});
          qmlComponent = Qt.createComponent("qrc:/ModeOptions/ModeOptionsStatus.qml");
          break;

        case "Bars":
//          Qt.createComponent("qrc:/ModeOptions/ModeOptionsBars.qml").createObject(mainView);
          qmlComponent = Qt.createComponent("qrc:/ModeOptions/ModeOptionsBars.qml");
          break;

        default:
//          console.log("(!) unable to handle " + mode.name);
          return;
      }

      if (qmlComponent.status == Component.Ready) {
        finishCreation(qmlComponent, mode);
      } else if (qmlComponent.status == Component.Error) {
        console.log("(!) component status error (" + mode.name + "):" + qmlComponent.errorString());
      } else {
        console.log("(!) component not ready (" + mode.name + ")...");
        qmlComponent.statusChanged.connect(() => {finishCreation(qmlComponent, mode);});
      }
    });
  };

  let getMode = function (fnAfter) {
    log("getMode()");

    apiGet("/led/mode", (responseObject) => { onModeResponse(responseObject); if (fnAfter) fnAfter(); });
  };

  let setMode = function (modeIndex) {
    log("setMode(" + modeIndex + ")");

    apiSet("/led/mode", {"index": modeIndex}, onModeResponse);
  };

  let setModeOptions = function (modeOptions) {
    log("setModeOptions(" + JSON.stringify(modeOptions) + ")");
    apiSet("/mode/options", modeOptions, onModeResponse);
  };

  let onModeResponse = function (modeObject) {
    log("onModeResponse(" + JSON.stringify(modeObject) + ")");
    state.mode = modeObject;
    mainView.currentItem.modeOptions = modeObject.options;
    // mode.name.text = state.mode.name;
    // FIXME set current view depending on "mode.name"
/*    mainView.currentIndex = state.mode.index

    switch (state.mode.index) {
      case 0:
        // status: no options
        break;
      case 1:
        // bars
        sliderBarsFadeRate.value = state.mode.options.fadeRate;
        sliderBarsBarsRate.value = state.mode.options.barsRate;
        break;
      case 2:
        // multi bars
        sliderMultiBarsFadeRate.value = state.mode.options.fadeRate;
        sliderMultiBarsTravelSpeed.value = state.mode.options.barTravelSpeed;
        sliderMultiBarsNumberOfBars.value = state.mode.options.numberOfBars;
        sliderMultiBarsMaximumFrameDelay.value = state.mode.options.maximumFrameDelay;
        break;
      case 3:
        // fireworks
        sliderFadeRate.value = state.mode.options.fadeRate;
        sliderSparkRate.value = state.mode.options.sparkRate;
        break;
      case 4:
        // sample: no options
        break;
      case 5:
        // hsiboy
        sliderAnimateSpeed.value = state.mode.options.animateSpeed;
        comboAnimation.currentIndex = state.mode.options.animation;
        break;
    }
*/
  };

  /* ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ******/

  let apiGet = function (path, callback) {
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function () {
      try {
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
      } catch (e) {
        hndlError(e)
      }
    };

    xhr.open("GET", apiBaseUrl() + path);
    xhr.send();
  };

  let apiSet = function (path, data, callback) {
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function () {
      try {
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
      } catch (e) {
        hndlError(e)
      }
    };

    xhr.open("POST", apiBaseUrl() + path);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.send(JSON.stringify(data));
  };

  let hndlHeaders = function (xhr) {
    // log("headers: " + xhr);
    // TODO handle 4xx, 5xx, etc
    if (xhr.status != 200) {
      log("ERROR: response!=200 => " + xhr.status);
    }
  };
  let hndlLoading = function () {
    control.state = "loading";
  };
  let hndlDone = function (xhr) {
    // log(xhr.response);
    control.state = "ready";
  };
  let hndlError = function (error) {
    log("ERROR: " + error);
    control.state = "offline";
  };

  let log = function (text) {
    console.log("API: " + text);
  };

  /* ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ******/

  return {
    state,
    setHost,
    update,
    getPower,
    setPower,
    togglePower,
    getMode,
    setMode,
    setModeOptions,
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
