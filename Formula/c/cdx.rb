class Cdx < Formula
  desc "Use Codex more easily, even away from your desk"
  homepage "https://github.com/ezpzai/cdx"
  url "https://registry.npmjs.org/@ezpzai/cdx/-/cdx-1.0.12.tgz"
  sha256 "4365718a6a15cae9300a42cb508abffdba0edddf69fe6b9d21feffd972d9c3cc"
  license "Apache-2.0"
  head "https://github.com/ezpzai/cdx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "ee1a831809b37ef43056ef7073302a086d2a39e552f407bac8e23de4ef354e15"
    sha256                               arm64_sequoia: "de6096129fac742bd761d6ad06c4bc9843b6b1fdbfd034d2975ba3ba498834b7"
    sha256                               arm64_sonoma:  "a675f4635e34b6588bd54d951972c069469ef260373243ec6b507441849b8b2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9f67b0c6bbdeddd6c3c43f6a2bf2532573af0e6d499fb64a022b6356d3bde5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a23bcc32695dd02e3512f0947e58450d8ce652393950665bcae0ba95fe30294a"
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
