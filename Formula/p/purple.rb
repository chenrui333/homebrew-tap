class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "432cfaabd6998443ee3672ed30261719d0e1bed53724d8e4bcc76757783d08f0"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93b76a323eb80031f7c1e37e6f3687820627293b57a85502bb1796eb0653f2f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4464f0f52e21b4f3880c9942d49d64f8d5894a3059db297f5ad886a75b529e41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c3eab2d1e29cf788c8b36d16a184871edde6580d6b7ceabb9a6b60e0f5d47d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74ddb95982f921ca011b407a690db859f4caa09e40d68d2a493e39806fee58f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f2b45155cc6e61d6ce5e03cebe63ecf0c817c9311b3fee6c82e46c1e7269f4b"
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
