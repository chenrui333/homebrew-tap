class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.25.8.tar.gz"
  sha256 "461542c1c8ad88c0552982dac71751aedf732f7946eb9f2ee63e72374b8f886c"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0118d70e3bb79e424d738fd6d53a9eeff8fdc30fe1b9fc4f6b0ca99d2b2c0d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee1feeba0679b1eb7de50222e80d21df7249efa616906ea28d0f5792a5833534"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b7bb8fe5de538b9bcb37a4f6a995e9af8c8e72430c9680c8f856c12ca6d50f9"
    sha256 cellar: :any,                 arm64_linux:   "757b17aea5f182d29562ae324c43d480965f7f9543e81d779c25e986bfbb8fdb"
    sha256 cellar: :any,                 x86_64_linux:  "362b5eb03b6e654f1263a498f50e4e74d9011e40ea6ef0e44feb10a8d45377f0"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
