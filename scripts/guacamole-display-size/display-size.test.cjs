const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const { test } = require('node:test');

function createClient(density) {
    const window = { devicePixelRatio: density, innerWidth: 3840, innerHeight: 2160 };
    const requests = [];
    const ManagedClient = {
        getInstance() {
            return { client: { sendSize(width, height) { requests.push([width, height]); } } };
        },
        // Match Guacamole 1.6.0's physical-pixel handshake calculation.
        connect(client, width, height) {
            requests.push([Math.floor(width * (window.devicePixelRatio || 1)),
                Math.floor(height * (window.devicePixelRatio || 1))]);
        }
    };
    vm.runInNewContext(fs.readFileSync(path.join(__dirname, 'display-size.js'), 'utf8'), {
        angular: { module() { return { config(definition) {
            definition.at(-1)({ decorator(name, decorator) {
                assert.equal(name, 'ManagedClient');
                decorator.at(-1)(ManagedClient, window);
            } });
        } }; } }
    });
    return { ManagedClient, window, requests, client: ManagedClient.getInstance() };
}

test('initial handshake and dynamic resize use the same bounded resolution', () => {
    const cases = [
        [1280, 800, 1280, 800],
        [1920, 1080, 1920, 1080],
        [3840, 2160, 1920, 1080],
        [3440, 1440, 1920, 803],
        [1200, 1920, 675, 1080],
        [800, 600, 800, 600]
    ];
    for (const density of [1, 1.25, 2, 3]) {
        const { ManagedClient, client, requests } = createClient(density);
        for (const [width, height, expectedWidth, expectedHeight] of cases) {
            ManagedClient.connect(client, width, height);
            client.client.sendSize(width * density, height * density);
            assert.deepEqual(requests.splice(0), [
                [expectedWidth, expectedHeight], [expectedWidth, expectedHeight]
            ], `${width}x${height} at pixel density ${density}`);

            // Guacamole's auto-fit fills both axes to within rounding of one
            // remote pixel, even when it must enlarge a capped desktop.
            const scale = Math.min(width / expectedWidth, height / expectedHeight);
            assert.ok(width - expectedWidth * scale <= scale + 0.001);
            assert.ok(height - expectedHeight * scale <= scale + 0.001);
        }
    }
});

test('resizing after a pixel density change uses the current screen density', () => {
    const { client, window, requests } = createClient(2);
    client.client.sendSize(2880, 1800);
    window.devicePixelRatio = 1;
    client.client.sendSize(1440, 900);
    assert.deepEqual(requests, [[1440, 900], [1440, 900]]);
});

test('handshake falls back to window dimensions when none are supplied', () => {
    const { ManagedClient, client, requests } = createClient(2);
    ManagedClient.connect(client);
    assert.deepEqual(requests, [[1920, 1080]]);
});
