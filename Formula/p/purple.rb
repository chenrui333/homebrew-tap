class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.25.0.tar.gz"
  sha256 "7cfb5f5ed0580c5323ada338514d12f94105711ce310814c2ceed5030b19b9c4"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0413668dec418d90df78b907fdcd629d6c6847640a28a5866c11346c1c544503"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6a6baa55198ca07262bc58979797a725a11282f2796da44954a54a0681f5b68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0f0f16bc5bd24ac42d2aba82a60d643526f16a4e3b4ccf974f57c27dcdfcaba"
    sha256 cellar: :any,                 arm64_linux:   "d8c9c080cece188e7f6b9048d0e6648813c8ffec49413c983e75d175f0bb73b7"
    sha256 cellar: :any,                 x86_64_linux:  "093a94fc829082f8d94da282f59033dfd2bb732e5e579545b2456dd175238916"
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
