process.env.FUNCTIONS_DISCOVERY_TIMEOUT = "120";

const { spawnSync } = require("child_process");

const result = spawnSync(
  "npx",
  ["-y", "firebase-tools@latest", "deploy", "--only", "functions"],
  {
    stdio: "inherit",
    shell: true,
    cwd: __dirname,
    env: process.env,
  },
);

process.exit(result.status === null ? 1 : result.status);
