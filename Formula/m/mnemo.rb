class Mnemo < Formula
  desc "Local-first AI memory layer with knowledge graph and semantic retrieval"
  homepage "https://github.com/zaydmulani09/mnemo"
  url "https://github.com/zaydmulani09/mnemo/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "840dabaf752b5b5ebd385bb353d6eb521581d7ac7963c9bfc43601a89e4b2248"
  license "MIT"
  head "https://github.com/zaydmulani09/mnemo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27c80b5c9d139906e71cf80ff4c0372039e484867546f7f27132ee8af6cd4677"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "582ae9a2d0cb5785a5454b80fc75a01232598f9e6f7050c72f45526d8c4a0b27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f20e79e47c9e814eeda45e9a01b99bb191e9ffef0771d3c23d1f7e6980ea996"
    sha256 cellar: :any,                 arm64_linux:   "7b1e43334efadd7c712178d914e38f45bb81168472e3c86ed93c931808e7a24b"
    sha256 cellar: :any,                 x86_64_linux:  "cb3112833403082b619f85dff6561d22fb43b9bc02dcfbb5690761fb68046fb1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mnemo-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mnemo-cli --version")
    assert_match "mnemo", shell_output("#{bin}/mnemo-cli --help")
  end
end
