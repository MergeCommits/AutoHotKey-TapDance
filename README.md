# AutoHotKey-TapDance
Provides an AutoHotKey library that adds QMK-like tap dance features.

## Usage

Import the library

    #include TapHoldSwing.ahk

Define a key to act as the gateway for a tap dance

    tapDance := new TapHoldSwing("a", Func("TapDanceCallback"));

Define a callback that accepts the number of taps

    TapDanceCallback(taps) {
        if (taps == 1) {
            Tooltip, "you tapped a once"
        } else if (taps == 2) {
            Tooltip, "you tapped a twice"
        } else if (taps == 3) {
            Tooltip, "you tapped a three times"
        } else if (taps == 4) {
            Tooltip, "yeah you get the idea"
        }
    }

# Parameters

## `prefix`
<table>
  <tr>
    <th>Description</th>
    <td>Changes the prefix used for the hotkeys.</td>
  </tr>
  <tr>
    <th>Default value</th>
    <td><code>$</code></td>
  </tr>
</table>

## `tapThresholdTime`
<table>
  <tr>
    <th>Description</th>
    <td>The amount of time to wait between each tap before timing out.</td>
  </tr>
  <tr>
    <th>Default value</th>
    <td><code>400</code>. Unit is milliseconds.</td>
  </tr>
</table>

Note that the threshold is **per tap**.
Each time you tap the key in a sequence, it will reset the threshold back to the time specified.
By default, this gives you 400ms between each tap to tap the key again.

Any taps beyond this threshold will be treated as novel taps of the key.

## `maxTaps`
<table>
  <tr>
    <th>Description</th>
    <td>Changes the maximum number of taps before the counter resets.</td>
  </tr>
  <tr>
    <th>Default value</th>
    <td><code>-1</code>. Putting any negative number disables this parameter.</td>
  </tr>
</table>

When you use a tap dance key, the library will wait a certain amount of time before firing the callback to make sure the key isn't tapped again.

For instance, the following code has this behavior:

```
tapper := new TapHoldSwing("1", Func("Test"))
tapper.tapThresholdTime := 400

Test(taps) {
    if (taps == 1) {
        Send {1}
    } else if (taps == 2) {
        Send {2}
    }
}
```

    Tap once --> waits 400ms --> sends "1"
    Tap once --> tap twice --> waits 400ms --> sends "2"

If you only have two actions, and you want to avoid the delay when sending "2", you can use this option:

```
tapper := new TapHoldSwing("1", Func("Test"))
tapper.tapThresholdTime := 400
tapper.maxTaps := 2

Test(taps) {
    if (taps == 1) {
        Send {1}
    } else if (taps == 2) {
        Send {2}
    }
}
```

    Tap once --> waits 400ms --> sends "1"
    Tap once --> tap twice --> sends "2" immediately

One gotcha to note is that this resets the tap counter stored in the library.
For example, tapping the key 4 times would normally do nothing since the callback doesn't specify an action for 4 taps.
However, when `maxTaps` is used tapping 4 times will send "22".
That's because any taps sent after the `maxTaps` count will immediately act like new taps.

## `fireTapsWithNoDelay`
<table>
  <tr>
    <th>Description</th>
    <td>Fires the taps callback immediately with no delay.</td>
  </tr>
  <tr>
    <th>Default value</th>
    <td><code>false</code></td>
  </tr>
</table>

When you use a tap dance key, the library will wait a certain amount of time before firing the callback to make sure the key isn't tapped again.

For instance, the following code has this behavior:

```
tapper := new TapHoldSwing("1", Func("Test"))
tapper.tapThresholdTime := 400

Test(taps) {
    if (taps == 1) {
        Send {1}
    } else if (taps == 2) {
        Send {2}
    }
}
```

    Tap once --> waits 400ms --> sends "1"
    Tap once --> tap twice --> waits 400ms --> sends "2"

Sometimes however you may want the tap actions to fire right away instead of having delays between them.

For instance, if you want a key to send a copy shortcut when tapped and cut shortcut when double tapped, you would want the copy shortcut to fire with no delay. Otherwise, you'd need to make sure you to don't press the key, then change cursor focus before the copy actually fires.

You can fix this with the code below:

```
tapper := new TapHoldSwing("1", Func("Test"))
tapper.tapThresholdTime := 400
tapper.fireTapsWithNoDelay := true

Test(taps) {
    if (taps == 1) {
        Send {1}
    } else if (taps == 2) {
        Send {2}
    }
}
```

    Tap once --> sends "1" immediately
    Tap once --> sends "1" immediately --> tap twice --> sends "2" immediately

Double tapping here will now send "12" without any delays.
Do note that `tapThresholdTime` is still used to track the number of taps fired.

