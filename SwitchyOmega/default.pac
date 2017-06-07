var FindProxyForURL = function(init, profiles) {
    return function(url, host) {
        "use strict";
        var result = init, scheme = url.substr(0, url.indexOf(":"));
        do {
            result = profiles[result];
            if (typeof result === "function") result = result(url, host, scheme);
        } while (typeof result !== "string" || result.charCodeAt(0) === 43);
        return result;
    };
}("+auto switch", {
    "+auto switch": function(url, host, scheme) {
        "use strict";
        if (/(?:^|\.)twitter\.com$/.test(host)) return "+foreign";
        if (/(?:^|\.)docker\.com$/.test(host)) return "+iran";
        if (/(?:^|\.)developers\.google\.com$/.test(host)) return "+iran";
        if (/(?:^|\.)firebase\.google\.com$/.test(host)) return "+iran";
        if (/(?:^|\.)googleusercontent\.com$/.test(host)) return "+iran";
        if (/(?:^|\.)godoc\.org$/.test(host)) return "+iran";
        if (/(?:^|\.)mbed\.com$/.test(host)) return "+iran";
        return "DIRECT";
    },
    "+foreign": function(url, host, scheme) {
        "use strict";
        if (/^127\.0\.0\.1$/.test(host) || /^::1$/.test(host) || /^localhost$/.test(host)) return "DIRECT";
        return "PROXY proxy.example.com:8080";
    },
    "+iran": function(url, host, scheme) {
        "use strict";
        if (/^127\.0\.0\.1$/.test(host) || /^::1$/.test(host) || /^localhost$/.test(host)) return "DIRECT";
        return "PROXY us.mybestport.com:443";
    }
});
