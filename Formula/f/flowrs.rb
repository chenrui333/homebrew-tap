class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "57c5a1e041ffdcd5443751e2bee3779b505c4aa2f39f1c2df4696301a8536ff0"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "324397e8107c06b283f245d7ad432f1f53adcc36ec01cf1148827580360e4c2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de871f714b12313819a3e3ffa77985040b1479410795d1c0bab3ce4f4ea862fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3449db2085d9905dcbee833e0457578f8ca48261e5fde5e4f5871564b34076e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e957d5586b5ff585e7dcfc93a895ec9eaf4a41202d6d8d9877da414a03c1b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e3b3e9f879e82293bab9da11f01bc993f5cb7e6d0afa0b880f42cd288ef22f6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
