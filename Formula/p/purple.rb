class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.17.tar.gz"
  sha256 "0e66d218b854d33d7d46443d10731483a4444fa430673d37b04fbeaccc8d4502"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c838e3b65eaa51f3f7ef2c5173c71aad6b7cbafafbad39884e956906a090ac4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70a6f3184a420eabaa805baa3ba334a19c502bac55c7407829e603dc72fedcde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "975030483a191f3b91f708c13e5f7f6d4bde4652b4d27f7a08cebe3e950e14a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88dadb46920be8adf2fd990cc50e52a5abedea80880a01fcbbd3a0c81511c36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0347414d3b453bb6d57eadc62548591b90886b80bbbce07290d980b6473647ff"
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
