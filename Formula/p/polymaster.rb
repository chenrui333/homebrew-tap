class Polymaster < Formula
  desc "Monitor large transactions on Polymarket and Kalshi prediction markets"
  homepage "https://github.com/neur0map/polymaster"
  url "https://github.com/neur0map/polymaster/archive/95277b34c66eaa307d169cec45320ffa9f2403a0.tar.gz"
  version "0.2.0"
  sha256 "235e3078ee8a9a348d9d75389e7c6f5837c0f4dbd6b748c03b3c9b49b88f8fa7"
  license :cannot_represent
  head "https://github.com/neur0map/polymaster.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d15fe522adfcca5b3d03bd7944cd70122bfed8c28304d0665f1a8360b96b60fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91ad6d30b041d86bb4e243fa8f3bdea79412cac8c3418e78069e379bf449ba04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "391eb37d740aeee13ed0018f58f78ccb013de0de97d5fbcfa9c776b35d5e2fb3"
    sha256 cellar: :any,                 arm64_linux:   "e2e8a03cda14571617944d44f5a54b7218614d350f6cbdc72b974d838ef227d7"
    sha256 cellar: :any,                 x86_64_linux:  "0fcfbf89e5857c7823bd67e928cc65aa8d759639e4f46c75ad1be169b6d81a2d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    assert_match "WHALE WATCHER STATUS", shell_output("#{bin}/wwatcher status")
  end
end
