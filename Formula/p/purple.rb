class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.20.0.tar.gz"
  sha256 "e5294c49fe148b554c14331bbf525cbfaa6a508fddac5563881781885445de5a"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b3eea65a961516989f804aa631aea4cb82da56a8e2d547c6b9da99e5c8935d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "181dfc912586c2bd092a213b375e0b0912d4bf97c3a9a620c172340ccbf2ac6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e98b15ef74e4e08591f37d1d617b33d80d28ece5027cc4208c17bd03294765d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70ee2193a2a130f76f676bcd2c0c9d5726719ba3b5dc535b08f5d16004e54e74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b71b3a2b4fe61b9c57bed50fb049b12616c056cda721645383f785443d0dbd0f"
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
