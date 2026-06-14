class Tabminal < Formula
  desc "Cloud-Native, Proactive AI Integrated Terminal works in modern browsers"
  homepage "https://github.com/Leask/Tabminal"
  url "https://registry.npmjs.org/tabminal/-/tabminal-3.0.40.tgz"
  sha256 "c931b8448a1ac2c0000ac88669e0e42c8871508fd278a39615d6a2eb829a2720"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d30279847b5d273e0b582c858c41052281a7bfdf0ad05b272c9dafcdc700a6ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d30279847b5d273e0b582c858c41052281a7bfdf0ad05b272c9dafcdc700a6ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d30279847b5d273e0b582c858c41052281a7bfdf0ad05b272c9dafcdc700a6ce"
    sha256 cellar: :any,                 arm64_linux:   "44dd65010d1cdc1d810723efa1a41c5f51dc621163c8cac8c747badaf76b1d3a"
    sha256 cellar: :any,                 x86_64_linux:  "60c268fd00be897eb5345d976bb7abadcc730f6315fd660bc87ce60f87c22956"
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
