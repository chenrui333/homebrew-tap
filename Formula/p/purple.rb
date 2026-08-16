class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.26.0.tar.gz"
  sha256 "6c5b6877b5ed13e978d998eea9675a82b33f44f156693bf8f14acb684c7c66d4"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d20b6dfa654df8a70becac28282ac3ad4a4588880f50bf8fb6e060f2fe4bfb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff40c9d46a3859d3e7c7343704b1b3c29deb34d05c2959841a420dbfdb7e8341"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "524945b25ae75bd61a6d9da81fce6ca235aa16a4bd72b6b845463c7ec39eebb8"
    sha256 cellar: :any,                 arm64_linux:   "b266f1bdb4582a03905e3d2601c7dc478a3f0e628c3ea1ddca61a821f69a6284"
    sha256 cellar: :any,                 x86_64_linux:  "398b02e27f3c8689f917c121427612ef5000d944b6e5fc2e2143a7f38da2838b"
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
