class Kimiflare < Formula
  desc "Terminal coding agent powered by Kimi-K2.6 on Cloudflare Workers AI"
  homepage "https://github.com/sinameraji/autopilot"
  url "https://registry.npmjs.org/kimiflare/-/kimiflare-1.0.0.tgz"
  sha256 "bdff615e92c826df9c3f93160ca90d2251a94527ea5fc246df570043bb6d62e8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2b5df1a11850b845a683595b69a0301e9e896ef2998d79cebcfb72444fb38e59"
    sha256 cellar: :any,                 arm64_sequoia: "4eccd625a2fb042251ee3d2a57c06670464fdaab08af2ca0e45b93d5aa7e7f43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12900b43ab67e3c0956f1efb7965713269d95300bb2d6eef0bdb88c0c1efc7ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06c0439878f3214f2db4c0d669d866ea203269d6fb3d5d07223108b407f2978a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
