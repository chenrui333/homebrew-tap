class Zaly < Formula
  desc "Hackable terminal coding agent"
  homepage "https://zaly.dev"
  url "https://github.com/folke/zaly/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "530b71a1cd7fe3a763aa9c0543185f63f11dcee8385d588729200844cf7f1f9d"
  license "MIT"
  head "https://github.com/folke/zaly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "411d97c5a357417150dc384999f9b7c3a145062719967c533ac30f7240b13c78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "338b92cd38e295f8f77f3fe241951c22e1d620c85864164c95a7950a8035fa4a"
    sha256 cellar: :any,                 arm64_linux:   "fa63ebdb10d37b11d8d06fed17044366529019599810db0bdd656e216174f7b6"
    sha256 cellar: :any,                 x86_64_linux:  "42bff3526da8dd4f7a46b348d4530881e5229a621ff21e56f034787f2423baeb"
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
