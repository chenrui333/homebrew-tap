class Outside < Formula
  desc "Multi-purpose weather client for your terminal"
  homepage "https://github.com/BaconIsAVeg/outside"
  url "https://github.com/BaconIsAVeg/outside/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "012cde0c824c044a15dd3a053b3a84c3d7aeb08f922215e50d70b0e426478de4"
  license "AGPL-3.0-or-later"
  head "https://github.com/BaconIsAVeg/outside.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aede5b378815d3f2d1d43fabed32212aeff90e6578562d8d6515cbe1a0b351bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52c5e0f2dba46dace5f17a91c8ca1c556807bb94e234b4ce128b62a654d6bc3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d61c0acded3799a2b9e2a1807bc214b4096f120262c8831dbb0915c592a9f0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e18e691261282637c6631b341a61093a745bf25064f20d42c2286c2d123e3f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5de99b0823671cd83808cfd9cfa67a113afc226fd221516ef85b34ea28b664a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    inreplace "Cargo.toml", 'openssl = { version = "0.10", features = ["vendored"] }', 'openssl = "0.10"'

    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/outside --version")

    output = shell_output("#{bin}/outside --stream --output tui 2>&1", 1)
    assert_match "TUI mode cannot be used with streaming mode", output
  end
end
