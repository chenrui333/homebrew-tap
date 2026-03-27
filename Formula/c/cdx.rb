class Cdx < Formula
  desc "Use Codex more easily, even away from your desk"
  homepage "https://github.com/ezpzai/cdx"
  url "https://registry.npmjs.org/@ezpzai/cdx/-/cdx-1.0.8.tgz"
  sha256 "119d1de48e457115a10dca70911550234aff83bb5f18dddf0d67d3736febd7fd"
  license "Apache-2.0"
  head "https://github.com/ezpzai/cdx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "6232301cc9ec7a2631e22b7ee2b745c799184ea95095d4532f364de09619a1d0"
    sha256                               arm64_sequoia: "015927a461bf5d9018a3cdde78a7ca1f8fec805b8e73ff874d734a62e17b089a"
    sha256                               arm64_sonoma:  "2610ef1a49cf9f4ebc46dfb9c242a45f39b519c5c6fc55aa05468392500b8f83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ba774be582f2d1062257cc24343a3eff359bc8d77064deb3fb7ada188b06daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36daaeb454af7d27578727d1fe87bacd9ae340fab17effe424757422b86231f7"
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
