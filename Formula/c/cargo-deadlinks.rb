class CargoDeadlinks < Formula
  desc "Cargo subcommand to check rust documentation for broken links"
  homepage "https://github.com/deadlinks/cargo-deadlinks"
  url "https://github.com/deadlinks/cargo-deadlinks/archive/refs/tags/0.8.1.tar.gz"
  sha256 "1557b197eb212c2f7e9530f382627b732ffcb14410109bf26cacaab28b26bddf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/deadlinks/cargo-deadlinks.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f157fb00413be1f6ebc8ebdae777069c5725104d67ab74d6b61befa4dfca13fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7729b8339b882dc76d6144ca6d95f0b52126745308429b2f3242d7494c482378"
    sha256 cellar: :any_skip_relocation, ventura:       "b3bffdc5bc224e00b54b3a3086b63eba209a7ec74545e71c539338e2f953f2f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddce268bcccca22f7ff4ae58e367f3d019c595eccf191bff6dfe44698cf5696c"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    # Switch the default toolchain to nightly
    system "rustup", "default", "nightly"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "toolchain", "install", "nightly"

    assert_match version.to_s, shell_output("cargo deadlinks --version")

    (testpath/"docs").mkpath
    (testpath/"docs/index.html").write <<~HTML
      <!DOCTYPE html>
      <html>
        <body>
          <a href="https://example.com">Valid Link</a>
        </body>
      </html>
    HTML

    system "cargo", "deadlinks", "--dir", testpath/"docs"
  end
end
