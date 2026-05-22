class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.10.tar.gz"
  sha256 "504fe650400137e4e8acb81f387c4c2b33412124033d65626ee367f7f6261110"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cb51720ec0ac77f76881143b3e3e5723e4fdb06b41ac78ed7ec6dd356bcdb91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9f2a8c7e037cf4b1d1bd20e2dab39b7fda664774c3441d6c6669fed371b7946"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8ca1e088f57fceb64d564b80994a92f9fd0d2977ff3844b5160b6bada53d929"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee73218397e43d051f81a93ac9aeb546234104535882199d3256e586a049fd86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af0562e1d20f62c39856a54a10a40b3b77d879a360f93c734e1b68e7665c6584"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")
  end
end
