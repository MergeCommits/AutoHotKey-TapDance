class TapHoldSwing {
    prefix := "$"
    binding := null
    callbackOnTaps := null

    bindingDown := false
    tapCount := 0
    maxTaps := -1
    tapTimeoutTimer := null

    tapThresholdTime := 400
    holdThresholdTime := 400

    fireTapsWithNoDelay := false
    fireHoldWithNoDelay := false

    __New(keyName, callbackOnTaps) {
        this.binding := keyName
        this.callbackOnTaps := callbackOnTaps

        this.SetupHotkey()
    }

    SetupHotkey() {
        fn := this.OnKeyDown.Bind(this)
        hotkey, % this.prefix this.binding, % fn, On
        fn := this.OnKeyUp.Bind(this)
        hotkey, % this.prefix this.binding " up", % fn, On
    }

    OnKeyDown() {
        if (this.bindingDown) {
            return
        }
        this.bindingDown := true

        if (this.maxTaps > 0 && this.tapCount >= this.maxTaps) {
            this.tapCount := 0
        }

        this.tapCount++
        
        if (this.tapTimeoutTimer != null) {
            if (!this.fireTapsWithNoDelay && this.tapCount == this.maxTaps) {
                this.FireTapCallback()
                this.KillTapTimer()
            } else {
                this.ResetTapTimer()
            }
        } else {
            this.StartTapTimer()
        }

        if (this.fireTapsWithNoDelay) {
            this.FireTapCallback()
        }
    }

    OnKeyUp() {
        this.bindingDown := false
    }

    FireTapCallback() {
        fn := this.callbackOnTaps.Bind(this.tapCount)
        SetTimer, % fn, -0
    }

    StartTapTimer() {
        this.tapTimeoutTimer := this.OnTapTimeout.Bind(this)
        timer := this.tapTimeoutTimer
        SetTimer, % timer, % this.tapThresholdTime
    }

    ResetTapTimer() {
        this.KillTapTimer()
        this.StartTapTimer()
    }

    KillTapTimer() {
        timer := this.tapTimeoutTimer
        SetTimer, % timer, delete
        this.tapTimeoutTimer := null
    }

    OnTapTimeout() {
        if (!this.fireTapsWithNoDelay) {
            this.FireTapCallback()
        }
        this.KillTapTimer()
        this.tapCount := 0
    }
}


