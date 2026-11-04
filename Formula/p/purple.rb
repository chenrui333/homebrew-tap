class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.34.2.tar.gz"
  sha256 "c954d5093cdce0bb9725d25600f414da10f1f75bb5abfee9a47811484588d225"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50735c5031676690069c16143aeb3201d07a5ff45c34e1453bc3771faf60c5d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72d5c9089ccdeed563d780842772eff63ae303d87d0f062bf0b55089633e596a"
    sha256 cellar: :any,                 arm64_linux:   "3d3747302339c690b324b30b4c2affef1a4878752e3b04c527f5dea37b60942e"
    sha256 cellar: :any,                 x86_64_linux:  "e7794bbd44cc95d35c0b41d294985679dd7c01c2f32650dc4c63bbfd161562e4"
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
