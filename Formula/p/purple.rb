class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.32.0.tar.gz"
  sha256 "2d13c66968f6e5df4cc1c0df9bbf98862500b0796915e7f83d255af566db4f17"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5229927b7ac3c185ada4a3d1cb4c00caed6423d67d2bd0538ad5d350b3d2ec0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fadb5c009acba69500f2c0ddd50e8cbd9d951b62eb3397c3820024fc347d2d44"
    sha256 cellar: :any,                 arm64_linux:   "912d6832c6a81ec403301f2bfe09c83393309afaed7c8ee8afcdaa2ffcece5e4"
    sha256 cellar: :any,                 x86_64_linux:  "bdbaac0a209dc598434a117bcf98f8826a4d09cbcefee20095ce075e5326de42"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")

    (testpath/"ssh_config").write <<~EOS
      Host tap-test
        HostName 127.0.0.1
        User nobody
    EOS

    output = shell_output("#{bin}/purple --list --config #{testpath}/ssh_config")
    assert_match "tap-test", output
  end
end
