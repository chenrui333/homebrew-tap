class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.22.1.tar.gz"
  sha256 "9577df1839d10e1473a7772cabe4b10e3caae8486fc912ff630a29d8b6c8832a"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92379d23ceb1cddc5d6033b70c66d08d843d759844cb073847ec99285a59f8d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fd70fc429fd2fca925abf6caf3b8544677ff409a15fd86ca5383b943e4bff2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "199b5989ec39e40c862db69d715c7491f5d1b91cfe7308d80b72c42609d3dc1a"
    sha256 cellar: :any,                 arm64_linux:   "8c609679ba32935765d6d15653315482eb6fdeafffff708f5f3b6e31b1b64967"
    sha256 cellar: :any,                 x86_64_linux:  "e8cca3e09b206990bd3f1ac6b149cfc3c09b0730b24a798489ebbcd4ee205081"
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
