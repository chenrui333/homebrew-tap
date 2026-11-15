class Tabminal < Formula
  desc "Cloud-Native, Proactive AI Integrated Terminal works in modern browsers"
  homepage "https://github.com/Leask/Tabminal"
  url "https://registry.npmjs.org/tabminal/-/tabminal-3.0.42.tgz"
  sha256 "818d32e685945e9ebfdd62c524339987ae96b801d97b08b2c784f40edf309107"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56bb91c0b2dd9d739c49971ab8da275b5cfb3433e6d76e2a6b1ae5a484d7227c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56bb91c0b2dd9d739c49971ab8da275b5cfb3433e6d76e2a6b1ae5a484d7227c"
    sha256 cellar: :any,                 arm64_linux:   "08e54df0a66a9194bc2f3b0aa387dc2f4dda4825ce93eda1f216d49cda9b975b"
    sha256 cellar: :any,                 x86_64_linux:  "a69da99c78773dbd56f8ef794307e9e00f1b7a82370a27847abfef2f9d22f260"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    if OS.linux?
      ENV["npm_config_build_from_source"] = "true"
      # Build node-pty against Homebrew's Node headers instead of downloading them.
      ENV["npm_config_nodedir"] = formula_opt_prefix("node")
    end
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args

    prebuilds = libexec/"lib/node_modules/tabminal/node_modules/node-pty/prebuilds"
    if OS.linux?
      cd libexec/"lib/node_modules/tabminal" do
        system "npm", "rebuild", "node-pty", "--build-from-source"
      end
      rm_r prebuilds if prebuilds.exist?
    elsif OS.mac? && Hardware::CPU.arm?
      rm_r prebuilds/"darwin-x64" if (prebuilds/"darwin-x64").exist?
    elsif OS.mac? && Hardware::CPU.intel?
      rm_r prebuilds/"darwin-arm64" if (prebuilds/"darwin-arm64").exist?
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "\"version\": \"#{version}\"", (libexec/"lib/node_modules/tabminal/package.json").read

    require "open3"

    output, status = Open3.capture2e(bin/"tabminal", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "No password provided", output
  end
end
