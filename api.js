var api = (function () {
  let apiHost = "10.13.37.222";
  let apiBaseUrl = function () {
    return "http://" + apiHost + "/api/v1"; // ! NOT "/" terminated
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

    // clear swipe view
    while (mainView.count > 0) {
      mainView.takeItem(0).destroy();
    }

    let finishCreation = (qmlComponent, mode) => {
      log("=> finishCreation (" + mode.name + ")...");
      qmlComponent.createObject(mainView, {
        api: api,
        modeName: mode.name,
        modeOptions: mode.options
      });
    };

    modesObject.modes.forEach(mode => {
//      log("=> create pane for " + JSON.stringify(mode));
      Qt.createComponent("qrc:/ModeOptions/ModeOptionsPane.qml");
      var qmlComponent;
      switch (mode.name) {
        case "Status":
          qmlComponent = Qt.createComponent("qrc:/ModeOptions/ModeOptionsStatus.qml");
          break;

        case "Bars":
          qmlComponent = Qt.createComponent("qrc:/ModeOptions/ModeOptionsBars.qml");
          break;

        case "MultiBars":
          qmlComponent = Qt.createComponent("qrc:/ModeOptions/ModeOptionsMultiBars.qml");
          break;

        case "Fireworks":
          qmlComponent = Qt.createComponent("qrc:/ModeOptions/ModeOptionsFireworks.qml");
          break;

        case "Sample":
          qmlComponent = Qt.createComponent("qrc:/ModeOptions/ModeOptionsSample.qml");
          break;

        case "Hsiboy":
          qmlComponent = Qt.createComponent("qrc:/ModeOptions/ModeOptionsHsiboy.qml");
          break;

        // case "Fire":
        //   qmlComponent = Qt.createComponent("qrc:/ModeOptions/ModeOptionsFire.qml");
        //   break;

        // case "Camera":
        //   qmlComponent = Qt.createComponent("qrc:/ModeOptions/ModeOptionsCamera.qml");
        //   break;

        // case "Network":
        //   qmlComponent = Qt.createComponent("qrc:/ModeOptions/ModeOptionsNetwork.qml");
        //   break;

        // case "Breathe":
        //   qmlComponent = Qt.createComponent("qrc:/ModeOptions/ModeOptionsBreathe.qml");
        //   break;

        // case "Text":
        //   qmlComponent = Qt.createComponent("qrc:/ModeOptions/ModeOptionsText.qml");
        //   break;

        case "Wave":
          qmlComponent = Qt.createComponent("qrc:/ModeOptions/ModeOptionsWave.qml");
          break;

        default:
//          log("(!) unable to handle " + mode.name);
          return;
      }

      if (qmlComponent.status == Component.Ready) {
        finishCreation(qmlComponent, mode);
      } else if (qmlComponent.status == Component.Error) {
        log("(!) component status error (" + mode.name + "):" + qmlComponent.errorString());
      } else {
        log("(!) component not ready (" + mode.name + ")...");
        qmlComponent.statusChanged.connect(() => {finishCreation(qmlComponent, mode);});
      }
    });
  };

  let getMode = function (fnAfter) {
    log("getMode()");

    apiGet("/led/mode", (responseObject) => { onModeResponse(responseObject); if (fnAfter) fnAfter(); });
  };

  let setMode = function (modeName) {
    log("setMode(" + modeName + ")");

    apiSet("/led/mode", {"name": modeName}, onModeResponse);
  };

  let setModeOptions = function (modeOptions) {
    log("setModeOptions(" + JSON.stringify(modeOptions) + ")");
    apiSet("/mode/options", modeOptions, onModeResponse);
  };

  let onModeResponse = function (modeObject) {
    log("onModeResponse(" + JSON.stringify(modeObject) + ")");
    state.mode = modeObject;

    for (var i = 0; i < mainView.contentChildren.length; i++) {
      const pane = mainView.contentChildren[i];
      if (pane.modeName == modeObject.name) {
        mainView.currentIndex = i;
        break;
      }
    }
    mainView.currentItem.modeOptions = modeObject.options;
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
