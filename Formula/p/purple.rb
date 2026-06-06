class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.22.0.tar.gz"
  sha256 "03d502cdefce93498d39474edff25ab7a06ddb0bb6ce0a4828d8416c47a72e82"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eabd37900c4591d4d50dc80de75da9632648410cf98718b7bd294ae0c39d8f7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edef1ae40cbfb204b179c71626a0d3a633e579c34cf0b48980cba1db45d6b5c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e4068353be8ce723c6fba18e88db42038c372ee0cc3befd7237830a165ba71f"
    sha256 cellar: :any,                 arm64_linux:   "b3c4fdaa93f8a42273af2d430143389bcd249d486b3c2f7f7de5088a81437d5d"
    sha256 cellar: :any,                 x86_64_linux:  "af35f6aa1c1b052f1646ec0f051a028995b40a01eff236146846b54b1d1b1145"
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
