class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "43a083bd89f0910251d333c230817790129bd106adfd30fdbb8393b45f111fcf"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2ecda99d335173f7ee66094415baa05598cb086dccd3fa08a541b9e4dd0af16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1062380d86c0b4f2b97b2551f9b7190869a57b04df1a1a321e84f93eaf06eedb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb018a5a6ffa74c2e6285ad5eccefdacebfcac287d6a5837bf920d7b7928ac39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bafd0cd320461b428978736bc8fd719b5c7392d45fc22d3cff7c37ffa62d637d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "803a3d1fce5263a3c0eebbacbf92d55387db0514785a132bd862d345e17cc7b1"
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
