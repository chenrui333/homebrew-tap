class Zaly < Formula
  desc "Hackable terminal coding agent"
  homepage "https://zaly.dev"
  license "MIT"
  head "https://github.com/folke/zaly.git", branch: "main"
  stable do
    url "https://github.com/folke/zaly/archive/refs/tags/v0.2.0.tar.gz"
    sha256 "18f45e022f9861bce78f05db9804a3d22c52f2aa998b8d93917a3365cea297be"

    # Keep Node alive while Shiki worker requests are pending.
    patch do
      url "https://github.com/folke/zaly/commit/84d33964e70cfa4520d5fa3385d4a3e72323fa1b.patch?full_index=1"
      sha256 "4c9cb05c50751c620669be582918959508fde9e9ba29bb3ef3710d1c84b0ebaa"
      type :unofficial
      resolves "https://github.com/folke/zaly/issues/66", "https://github.com/folke/zaly/pull/67"
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e1d9de2b2dd77ceecdab461a4ecc001eab93793f458026edc1e8dbbcce59069"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "032b044c9bce5df4d8e36fd348a31af737d2abf10cc25b241624c5cf819b4afc"
    sha256 cellar: :any,                 arm64_linux:   "6a901b9666ef242e2b45a7476e28dca0ebb96bb395c9b45687c288e1247651e1"
    sha256 cellar: :any,                 x86_64_linux:  "af793c2c9b71bbe68c0b5de104a3bd31dd216c4a771afbc9d6b67e1260b2ee66"
  end

  depends_on "bun" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  resource "sharp-node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.2.tgz"
    sha256 "4cd65698541b19a33f798f1dc25c02c6ed1c9d7749b8824b1a1ccecdd197c8ea"
  end

  deny_network_access!

  def fetch
    system formula_opt_bin("bun")/"bun", "install", "--frozen-lockfile", "--ignore-scripts"
  end

  def install
    bun = formula_opt_bin("bun")/"bun"
    system bun, "run", "build"
    # Production install does not prune an existing development dependency tree.
    rm_r "node_modules"
    rm_r buildpath.glob("{packages/*,plugins}/node_modules")
    system bun, "install", "--frozen-lockfile", "--production", "--ignore-scripts", "--filter", "!@zaly/dev"

    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    resource("sharp-node-addon-api").stage(buildpath/"sharp-node-addon-api")
    (pkgshare/"licenses/node-addon-api").install buildpath/"sharp-node-addon-api/LICENSE.md"
    sharp_pkg = (buildpath/"packages/shared/node_modules/sharp").realpath
    if sharp_pkg.relative_path_from(buildpath.realpath).to_s.start_with?("../")
      odie "Sharp resolved outside the isolated build tree"
    end
    addon_api = sharp_pkg/"node_modules/node-addon-api"
    addon_api.dirname.mkpath
    rm_r addon_api if addon_api.exist? || addon_api.symlink?
    ln_s buildpath/"sharp-node-addon-api", addon_api
    node_gyp = formula_opt_libexec("node")/"lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js"
    cd sharp_pkg do
      system formula_opt_bin("node")/"node", node_gyp, "rebuild", "--directory=src",
             "--nodedir=#{formula_opt_prefix("node")}", "--jobs=#{ENV.make_jobs}"
    end
    rm addon_api
    # Preserve interpreted @img/colour; replace only Sharp's native platform payloads.
    rm_r buildpath.glob("**/node_modules/@img/sharp-*", File::FNM_DOTMATCH)
    rm_r buildpath.glob("node_modules/.bun/@img+sharp-*")
    rm_r "packages/dev"

    # Preserve workspace-relative exports, worker entrypoints, themes, skills, and plugins.
    libexec.install "packages", "plugins", "node_modules", "package.json"
    (bin/"zaly").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/packages/cli/dist/zaly.mjs" "$@"
    SH
    chmod 0755, bin/"zaly"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zaly --version")
    ENV.delete "NO_COLOR"
    ENV["FORCE_COLOR"] = "3"
    config = shell_output("#{bin}/zaly --print-config --model homebrew/model --no-plugins")
    assert_match "homebrew/model", config
    (testpath/"native-image.cjs").write <<~JS
      const { createRequire } = require("node:module");
      const sharp = createRequire("#{libexec}/packages/shared/package.json")("sharp");
      sharp({ create: { width: 1, height: 1, channels: 3, background: "white" } })
        .png().toBuffer()
        .then((data) => console.log(data.subarray(0, 8).toString("hex")))
        .catch((error) => { console.error(error); process.exitCode = 1; });
    JS
    assert_match "89504e470d0a1a0a", shell_output("#{formula_opt_bin("node")}/node native-image.cjs")
  end
end
