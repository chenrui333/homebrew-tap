class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.2.tar.gz"
  sha256 "17cba142a55622a9b41f1fdd0248262cb50dc4a057c1324b92dcde88f75d8a2c"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "003c5d2a7d76ba4d54a9993fb159e25d12df37e87841c9fd64c0c589b43b7968"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a73eb3fe1d152cb39570f432703f4fe91eef148632755950e67ff4a5981d42e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82c0245321260e4fea5fee73dc900a76ba324db8fe35c1973fb1f9c838d55e61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11f4e7508cc63915e172ad610cf7f7bd90370da08cdb6ea7974a1f76b66cf374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b031eff3d83bbbe2171b419c9829a201f798b13be048b0caf6a7787f9bbc367"
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
