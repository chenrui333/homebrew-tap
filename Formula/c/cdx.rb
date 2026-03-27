class Cdx < Formula
  desc "Use Codex more easily, even away from your desk"
  homepage "https://github.com/ezpzai/cdx"
  url "https://registry.npmjs.org/@ezpzai/cdx/-/cdx-1.0.8.tgz"
  sha256 "119d1de48e457115a10dca70911550234aff83bb5f18dddf0d67d3736febd7fd"
  license "Apache-2.0"
  head "https://github.com/ezpzai/cdx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "10d514b3c80a6c62e1d16ab868577628b36c632594dc08dc940aa919eb672af1"
    sha256                               arm64_sequoia: "e2795f280480509ae49a284151a97e9c8f4c9333fb805edd6af499da6b51a13c"
    sha256                               arm64_sonoma:  "a6c28d10cf45554a4e8ec6cb8a9ef2d74491f41f07d86eb0ea543fcb3e900cc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01ca163771c926ffb365dd14f70adf68d42b64839602c274aec1e93897ae241e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c11c6120302eed30909ad13cd7f38253001ac11e0a2f57e01a2da054e3a058e2"
  end

  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  fails_with :clang do
    build 1699
    cause "node-pty fails to build"
  end

  def install
    ENV["npm_config_build_from_source"] = "true"
    system "npm", "install", *std_npm_args

    Dir.chdir(libexec/"lib/node_modules/@ezpzai/cdx") do
      system "npm", "rebuild", "node-pty", "--build-from-source"
    end

    rm_r(libexec/"lib/node_modules/@ezpzai/cdx/node_modules/node-pty/prebuilds", force: true)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    cdx_home = testpath/".cdx"

    with_env(CDX_HOME: cdx_home.to_s) do
      output = shell_output("#{bin}/cdx mode set balanced")
      assert_match "Set global default mode: balanced", output
      assert_match "balanced", shell_output("#{bin}/cdx mode")
    end

    assert_path_exists cdx_home/"config.json"
  end
end
