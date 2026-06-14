class TangentCli < Formula
  desc "Stream processing with real languages, not DSLs"
  homepage "https://docs.telophasehq.com/cli/overview"
  url "https://github.com/telophasehq/tangent/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "1bf27156e576d6cc62591bfb9f61edcfaed133166132579e4abad0d381b04210"
  license "MPL-2.0"
  head "https://github.com/telophasehq/tangent.git", branch: "main"

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
