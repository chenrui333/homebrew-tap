class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.32.1.tar.gz"
  sha256 "7efd62f6c5a06a96a39ca86152f7daee2f460bf668287ac2a17ff71f8c279223"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e6683716f24627e2cccc0383630c92c45b3a9718edc393caf88fd094f13c427"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5db4650512d163334895d20bfe9895759045b599def84f82dc80f878b955e84b"
    sha256 cellar: :any,                 arm64_linux:   "b5c6ea2f969ec5c48288b17022c74f248a71c9a6036f1358892d3f1fc18cce5e"
    sha256 cellar: :any,                 x86_64_linux:  "e34b29432c4663c9339deedeb5a2043f1fe86a744e725e51350dfa67ccc0ef0a"
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
