class Tuono < Formula
  desc "Superfast fullstack React framework"
  homepage "https://tuono.dev/"
  url "https://github.com/tuono-labs/tuono/archive/refs/tags/v0.19.7.tar.gz"
  sha256 "e74a90396d220302a55b378913467f09b717f5157e12201d0da3d120cfcde08b"
  license "MIT"
  head "https://github.com/tuono-labs/tuono.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99ef70436fe3429f8a2e4b823435d6b9a87a6152642cca0cb1862ac5d88ef965"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8a7e5ab46c11b5e34e550b477921bfeeaf32addb5e81f471e6e8874d4c01d38"
    sha256 cellar: :any,                 arm64_linux:   "58063b0162e3a3f21e3dd10bb18aea0d3e743c97d3729a654ebbeb124321a0cb"
    sha256 cellar: :any,                 x86_64_linux:  "fdf53ebbce1c4b87651f2903fc897c4aa0b709a358945009a5fe97c4b10de2ad"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    # Upstream does not commit Cargo.lock; resolve once during fetch so the build stays offline.
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tuono")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuono --version")

    # `tuono new` downloads templates from GitHub; exercise the offline Rust codegen instead.
    assert_match "Cannot find tuono.config.ts", shell_output("#{bin}/tuono build 2>&1", 1)

    (testpath/"tuono.config.ts").write "export default {}\n"
    (testpath/"src/routes/index.tsx").write "export default function Index() { return <h1>hi</h1> }\n"
    assert_match "Rust build successfully finished", shell_output("#{bin}/tuono build --no-js-emit")
    assert_match "axum::Router", (testpath/".tuono/main.rs").read
  end
end
