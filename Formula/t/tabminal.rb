class Tabminal < Formula
  desc "Cloud-Native, Proactive AI Integrated Terminal works in modern browsers"
  homepage "https://github.com/Leask/Tabminal"
  url "https://registry.npmjs.org/tabminal/-/tabminal-3.0.40.tgz"
  sha256 "c931b8448a1ac2c0000ac88669e0e42c8871508fd278a39615d6a2eb829a2720"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28a3e7782a08f4a42b5f4bf10dcb6b55c629811d6cb3ada3a604df591a8a56a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28a3e7782a08f4a42b5f4bf10dcb6b55c629811d6cb3ada3a604df591a8a56a5"
    sha256 cellar: :any,                 arm64_linux:   "0e5c7a444f2c6d6d75ba1ed723c966e4f1b54a87d4db23e528751de60a16bcb6"
    sha256 cellar: :any,                 x86_64_linux:  "982e0d93553cda83aace9d0d05d3cd1836370920c999f6dec2890a17f5def7c6"
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
