config.set("editor", "nvim");

const hostnameSymbol = Symbol("hostname");
const uptimeSymbol = Symbol("uptime");

prompt = () => {
  if (!db[hostnameSymbol]) db[hostnameSymbol] = db.serverStatus().host;
  if (!db[uptimeSymbol]) db[uptimeSymbol] = db.serverStatus().uptime;

  return `${db.getName()}@${db[hostnameSymbol]} [${db[uptimeSymbol]}]> `;
};

let mongoTuning = {};

/*
 * Query Profiler helper functions for the Apress book "MongoDB Performance Tuning"
 *
 * @Authors: Michael Harrison (Michael.J.Harrison@outlook.com) and Guy Harrison (Guy.A.Harrison@gmail.com).
 * @Date:   2020-09-03T17:54:50+10:00
 * @Last modified by:   Michael Harrison
 * @Last modified time: 2021-04-08T10:50:52+10:00
 *
 */
mongoTuning.profileQuery = () => {
  const profileQuery = db.system.profile.aggregate([
    {
      $group: {
        _id: { cursorid: "$cursorid" },
        count: { $sum: 1 },
        "queryHash-max": { $max: "$queryHash" },
        "millis-sum": { $sum: "$millis" },
        "ns-max": { $max: "$ns" },
      },
    },
    {
      $group: {
        _id: {
          queryHash: "$queryHash-max",
          collection: "$ns-max",
        },
        count: { $sum: 1 },
        millis: { $sum: "$millis-sum" },
      },
    },
    { $sort: { millis: -1 } },
    { $limit: 10 },
  ]);
  return profileQuery;
};

/**
 * Get details of a query from system.profile using the queryhash
 *
 * @param {string} queryHash - The queryHash of the query of interest.
 *
 * @returns {queryDetails} query ns, command and basic statistics
 */

mongoTuning.getQueryByHash = function (queryHash) {
  return db.system.profile.findOne(
    { queryHash },
    { ns: 1, command: 1, docsExamined: 1, millis: 1, planSummary: 1 }
  );
};

/**
 * Fetch simplified profiling info for a given database and namespace.
 *
 * @param {string} dbName - The name of the database to fetch profiling data for.
 * @param {string} collectionName - The name of the collection to fetch profiling data for.
 *
 * @returns {ProfilingData} Profiling data for the given namespace (queries only), grouped and simplified.
 */

mongoTuning.getProfileData = function (dbName, collectionName) {
  var mydb = db.getSiblingDB(dbName); // eslint-disable-line
  const ns = dbName + "." + collectionName;
  const profileData = mydb
    .getSiblingDB(dbName)
    .getCollection("system.profile")
    .aggregate([
      {
        $match: {
          ns,
          op: "query",
        },
      },
      {
        $group: {
          _id: {
            filter: "$query.filter",
          },
          count: {
            $sum: 1,
          },
          "millis-sum": {
            $sum: "$millis",
          },
          "nreturned-sum": {
            $sum: "$nreturned",
          },
          "planSummary-first": {
            $first: "$planSummary",
          },
          "docsExamined-sum": {
            $sum: "$docsExamined",
          },
        },
      },
      {
        $sort: {
          "millis-sum": -1,
        },
      },
    ]);
  return profileData;
};
