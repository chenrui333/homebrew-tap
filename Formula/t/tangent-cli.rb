class TangentCli < Formula
  desc "Stream processing with real languages, not DSLs"
  homepage "https://docs.telophasehq.com/cli/overview"
  url "https://github.com/telophasehq/tangent/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "1bf27156e576d6cc62591bfb9f61edcfaed133166132579e4abad0d381b04210"
  license "MPL-2.0"
  head "https://github.com/telophasehq/tangent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "1a4ba0113ca90ba22051bab6c9e691c91a0cf9118c9f89d9182526d99f72e836"
    sha256               arm64_sequoia: "7ebc317ff7e4aebaef16c315b8ac93f3cba393b9ad0e3dc101482b2731c5a012"
    sha256               arm64_sonoma:  "ad6ec2c78e27d19525bf61a0fa9fa380da42a0eab13cbd8679ba5a22f0fecae1"
    sha256 cellar: :any, arm64_linux:   "e4df75b9625e4cb9158a79c01dc5946ac4f8ef87dab6481c4265a6295d9412db"
    sha256 cellar: :any, x86_64_linux:  "074bc9166288ea80d03f9df6359d3e98c15d0f79a67c981d6ff49883510f2502"
  end

  depends_on "cmake" => :build # for rdkafka-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Upstream v0.1.10 tag still reports 0.1.9 in workspace metadata.
    inreplace "Cargo.toml", 'version = "0.1.9"', "version = \"#{version}\""

    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tangent --version")

    output = shell_output("#{bin}/tangent plugin scaffold --name brewtest --lang ruby 2>&1", 1)
    assert_match "unsupported --lang ruby", output
  end
end
