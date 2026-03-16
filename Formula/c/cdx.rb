class Cdx < Formula
  desc "Use Codex more easily, even away from your desk"
  homepage "https://github.com/ezpzai/cdx"
  url "https://registry.npmjs.org/@ezpzai/cdx/-/cdx-1.0.5.tgz"
  sha256 "db1568d7cff1d404d190d77572ee4d044106b979e1dda80ec0e72bbafc01943a"
  license "Apache-2.0"
  head "https://github.com/ezpzai/cdx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "7e58987ac351cb3bcbf7d54d3d9e52bbe760fdba1b6fc7a821ec233b837a3f47"
    sha256                               arm64_sequoia: "284f3ca90e5ebfc657f122b8300abf25db69c7b20e14c133cd150b70a2154629"
    sha256                               arm64_sonoma:  "c9bec8de32a7c3c81ce6debfd3b7633caa56c276447c14ea29c7b0923328329d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6f3ea8c313b90d7ba9ca6975b1e72ce2523285c4d12c55df7d00e81be44846e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8407160c1f237e937357b4e580b1ed87f406c6eaff0e837b0760f3daa76a4b30"
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
