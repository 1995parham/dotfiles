config.set("editor", "nvim");

const hostnameSymbol = Symbol("hostname");
const uptimeSymbol = Symbol("uptime");

prompt = () => {
  if (!db[hostnameSymbol]) db[hostnameSymbol] = db.serverStatus().host;
  if (!db[uptimeSymbol]) db[uptimeSymbol] = db.serverStatus().uptime;

  return `${db.getName()}@${db[hostnameSymbol]} [${db[uptimeSymbol]}]> `;
};
