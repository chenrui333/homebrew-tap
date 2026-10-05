class Kimiflare < Formula
  desc "Terminal coding agent powered by Kimi-K2.6 on Cloudflare Workers AI"
  homepage "https://github.com/sinameraji/autopilot"
  url "https://registry.npmjs.org/kimiflare/-/kimiflare-1.0.0.tgz"
  sha256 "bdff615e92c826df9c3f93160ca90d2251a94527ea5fc246df570043bb6d62e8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "da9286dda72e9c4814cacc7e648a2bfaa2c56e2d18e1bbb5cf32daa4653e4a9c"
    sha256 cellar: :any,                 arm64_sequoia: "da9286dda72e9c4814cacc7e648a2bfaa2c56e2d18e1bbb5cf32daa4653e4a9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9af43823852537fb4acb9f4886495ea0bb1fac61dabbb770fa8590cfb83c4d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52fdfd94db8a63105985c76d1ba0d6c231247e7af5754b1b0925fe49aec74e8e"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    prebuilds = libexec/"lib/node_modules/kimiflare/node_modules/isolated-vm/prebuilds"
    platform = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    keep = "#{platform}-#{arch}"
    if prebuilds.directory?
      prebuilds.children.each { |dir| rm_r(dir) if dir.basename.to_s != keep }
      (prebuilds/keep).glob("*.musl.node").each(&:unlink) if OS.linux?
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    require "json"

    # This compatibility shim forwards --version to its Autopilot dependency.
    autopilot = JSON.parse((libexec/"lib/node_modules/kimiflare/node_modules/autopilot-ai/package.json").read)
    output = shell_output("#{bin}/kimiflare --version 2>&1")
    assert_match autopilot.fetch("version"), output
    assert_match "kimiflare has been renamed to autopilot", output
    output = shell_output("#{bin}/kimiflare --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end
