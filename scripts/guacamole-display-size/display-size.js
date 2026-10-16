/* global angular */
'use strict';

// Use CSS pixels rather than Retina/device pixels for readable desktop controls.
// Keep the browser's aspect ratio so Guacamole's existing auto-fit also fills
// large, portrait and ultrawide windows (apart from pixel rounding).
angular.module('client').config(['$provide', function ($provide) {
    $provide.decorator('ManagedClient', ['$delegate', '$window', function (ManagedClient, $window) {
        const MAX_WIDTH = 1920;
        const MAX_HEIGHT = 1080;

        function desktopSize(width, height) {
            const scale = Math.min(1, MAX_WIDTH / width, MAX_HEIGHT / height);
            return {
                width: Math.max(1, Math.floor(width * scale)),
                height: Math.max(1, Math.floor(height * scale))
            };
        }

        const getInstance = ManagedClient.getInstance;
        ManagedClient.getInstance = function () {
            const managedClient = getInstance.apply(this, arguments);
            const client = managedClient.client;
            const sendSize = client.sendSize;

            // guacClient sends physical pixels on every browser/container resize.
            client.sendSize = function (width, height) {
                const density = $window.devicePixelRatio || 1;
                const size = desktopSize(width / density, height / density);
                return sendSize.call(this, size.width, size.height);
            };

            return managedClient;
        };

        const connect = ManagedClient.connect;
        ManagedClient.connect = function (managedClient, width, height) {
            const density = $window.devicePixelRatio || 1;
            const size = desktopSize(width || $window.innerWidth, height || $window.innerHeight);

            // ManagedClient.connect multiplies CSS dimensions by devicePixelRatio
            // for the handshake. Cancel that multiplication for the initial size
            // as well, so reconnects and later resize requests use the same limit.
            return connect.call(this, managedClient, size.width / density, size.height / density);
        };

        // Guacamole's standard auto-fit scales the desktop and mouse coordinates,
        // including scaling UP when the browser is larger than the capped desktop.
        return ManagedClient;
    }]);
}]);
