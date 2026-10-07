class TangentCli < Formula
  desc "Stream processing with real languages, not DSLs"
  homepage "https://docs.telophasehq.com/cli/overview"
  url "https://github.com/telophasehq/tangent/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "1bf27156e576d6cc62591bfb9f61edcfaed133166132579e4abad0d381b04210"
  license "MPL-2.0"
  head "https://github.com/telophasehq/tangent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35128f14ecd7c6dd1b16f1e9fa5c18e3d83fc68a06a7f01e5d3249cfb8c75fc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc64d00e098bcdfbd44d43a6312a3faa0d1e9ec6ff05b3194df533d3143dd162"
    sha256 cellar: :any,                 arm64_linux:   "337406a00ae1a3bb0e8f5bdbb2be062897b4d2f2b18f0f3846a397cc948c0364"
    sha256 cellar: :any,                 x86_64_linux:  "59bb925b8a850884705d7bf4c47301747ba1345956bbdf3ebef3bc52c3c60a36"
  end

  depends_on "cmake" => :build # for rdkafka-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
