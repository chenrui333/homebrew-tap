class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "e60ef7e056f643ccdd7ae0437abd64bad5884ecffde62edac85e2ebd31ec71b8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecbd6a4261622bf8428ea862e6a5700e207104f0f5ed5f73315773aa749acab0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e561cff193ae73a7616a65d62c335f5d38e0d14ef5624ff020bbdc67f2abbbfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5291aa053677e56fb93bec798f01a9377b3b472e93b4de9ccfb359f6c47fa37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19ff6d5cc398e294ab45177e3548519a28ab0e381ae2f430c3db1a61cc26a38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69832946645c0c618f59264b52db68a26dfbd2c2f1a6c1e3c140f74937f16518"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Settings", shell_output("#{bin}/ironclaw config list")
  end
end
