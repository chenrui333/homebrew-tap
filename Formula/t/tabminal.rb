class Tabminal < Formula
  desc "Cloud-Native, Proactive AI Integrated Terminal works in modern browsers"
  homepage "https://github.com/Leask/Tabminal"
  url "https://registry.npmjs.org/tabminal/-/tabminal-3.0.40.tgz"
  sha256 "c931b8448a1ac2c0000ac88669e0e42c8871508fd278a39615d6a2eb829a2720"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fb2331ebe189cfb057e6bd28444dca3dde35454e7beb1e7042bc3a793c052d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fb2331ebe189cfb057e6bd28444dca3dde35454e7beb1e7042bc3a793c052d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fb2331ebe189cfb057e6bd28444dca3dde35454e7beb1e7042bc3a793c052d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f608610036740ecc93d8feca9d847a6a00e913d3f1589f648025b8a7de48315b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f07776569eec758f0413084042fcf23f06f57a815f8782c90a5423575ff96c41"
  end

  depends_on "node"

  def install
    ENV["npm_config_build_from_source"] = "true" if OS.linux?
    system "npm", "install", *std_npm_args

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
