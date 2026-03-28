class Neoss < Formula
  desc "User-friendly and detailed socket statistics with a Terminal UI"
  homepage "https://github.com/PabloLec/neoss"
  url "https://registry.npmjs.org/neoss/-/neoss-1.1.11.tgz"
  sha256 "7d6390435eda02ca3157a3ca463e2db0282b774cab211d857bb322f423f2cee4"
  license "BSD-3-Clause"

  depends_on :linux
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/neoss"
  end

  test do
    node = Formula["node"].opt_bin/"node"
    (testpath/"test.js").write <<~JS
      const pkg = require("#{libexec}/lib/node_modules/neoss/package.json");
      const { getUserData } = require("#{libexec}/lib/node_modules/neoss/build/utils/users.js");

      (async () => {
        const [name, owner, cmdline] = await getUserData(process.pid.toString());
        if (pkg.version !== "#{version}") throw new Error(`unexpected version: ${pkg.version}`);
        if (!name || !owner || !cmdline.includes("test.js")) throw new Error("unexpected user data");
        console.log(`${pkg.version}|${name}|${owner}`);
      })().catch((error) => {
        console.error(error);
        process.exit(1);
      });
    JS

    output = shell_output("#{node} #{testpath/"test.js"}")
    assert_match version.to_s, output
  end
end
