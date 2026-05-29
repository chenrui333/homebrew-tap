class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.20.1.tar.gz"
  sha256 "7c9db310faf09cf8e55e496587e8036197ba08293ce61c527ba810691c4d3ce1"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b95b8eacd78fcadf209922b5978e1e2636367317e91a3b0162b929a0f79fb1dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93f0bad914b4261f39a09d996a1d178bbf01d06bf53dc15a3d15e253033caeb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dd3ce222f5929aa362c67fbea62cef82b836160762f73dbeebbe9a902d37235"
    sha256 cellar: :any,                 arm64_linux:   "4fca3d709f2b134cb0e5dc63db0b24794751aa5ce8bfc9e8035a6f664070381e"
    sha256 cellar: :any,                 x86_64_linux:  "a1b5874772270ef77aa0c8100ed5c274c434945a80dd24a89d3107daa041df0b"
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
