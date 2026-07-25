class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.23.0.tar.gz"
  sha256 "45d5c033f4cf5a77904fde748a5dece8791391329df354739f0ab81ee50ab2ef"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d88a5e4c8bf5ea28c108e10a4e3c96df293b854c4de39c8fe05191392b899f35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "595b2325d26a4a76a16bf89aec1685023f901af0d65a77676eba41f0511602d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73bd720fe1e2d33984c72e6e616aedede7d2e58bbc82aa5afb1b34208c6f1553"
    sha256 cellar: :any,                 arm64_linux:   "1d714e4f87a8c7a473ed4041d08fd949f2730b397169ca72160221fec97c8f06"
    sha256 cellar: :any,                 x86_64_linux:  "658d98a51ae874afe6ae68c5393fe5b306c5539a06099c776b6414c772a846af"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")
  end
end
