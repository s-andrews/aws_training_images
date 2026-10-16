# Desktop resolution limit

The Ubuntu build script installs this JavaScript-only Guacamole extension. It
targets Guacamole **1.6.0** and decorates its internal `ManagedClient` service;
review the sizing hooks before upgrading Guacamole.

The remote desktop uses browser CSS pixels, ignoring the extra physical pixels
on high-density screens. Its width and height are then limited proportionally
to **1920 x 1080**. Adjust `MAX_WIDTH` and `MAX_HEIGHT` in `display-size.js` to
change these limits. For example:

| Browser content area (CSS pixels) | Remote desktop |
| --- | --- |
| 1440 x 900, including a Retina screen | 1440 x 900 |
| 3840 x 2160 | 1920 x 1080 |
| 3440 x 1440 | 1920 x 803 |
| 1200 x 1920 | 675 x 1080 |

Both the initial handshake and subsequent resize requests use this policy.
VNC resizing stays enabled. Guacamole's existing auto-fit preserves the aspect
ratio and enlarges the capped desktop to fill the available browser area,
within pixel rounding. Its normal input scaling keeps clicks aligned. Users
can still manually zoom using the Guacamole menu.

To apply this to an existing server, run from the updated repository root:

```sh
sudo apt -y install zip
sudo mkdir -p /etc/guacamole/extensions
sudo zip -j /etc/guacamole/extensions/training-desktop-resolution.jar \
    scripts/guacamole-display-size/guac-manifest.json \
    scripts/guacamole-display-size/display-size.js
sudo systemctl restart tomcat10
```

Reload the browser page to load the extension and reconnect. Restarting Tomcat
interrupts existing browser sessions.

Run the sizing checks with:

```sh
node --test scripts/guacamole-display-size/display-size.test.cjs
```

On an actual server, check the desktop resolution with `xrandr --current` in
the remote terminal while resizing the browser, entering fullscreen, and moving
the browser between standard and Retina screens. Check wide and portrait
windows, confirm the desktop fills the content area with auto-fit enabled,
and check clicks near all four corners. A 1440 x 900 CSS-pixel window should
request 1440 x 900 even at device pixel ratio 2; a 3840 x 2160 CSS-pixel window
should request 1920 x 1080. Confirm the same behavior after a page reload and
server reboot.

References: [Guacamole extension format](https://guacamole.apache.org/doc/gug/guacamole-ext.html),
[Guacamole 1.6.0 sizing and auto-fit](https://github.com/apache/guacamole-client/blob/1.6.0/guacamole/src/main/frontend/src/app/client/directives/guacClient.js),
[initial connection sizing](https://github.com/apache/guacamole-client/blob/1.6.0/guacamole/src/main/frontend/src/app/client/types/ManagedClient.js).
