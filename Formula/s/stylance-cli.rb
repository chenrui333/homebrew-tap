class StylanceCli < Formula
  desc "Scoped CSS style imports for rust"
  homepage "https://github.com/basro/stylance-rs"
  url "https://github.com/basro/stylance-rs/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "d079f160a0b95dd2f801a14c15bfcfba82b4ae3e12d2222dd212ce8f894d2835"
  license "MIT"
  head "https://github.com/basro/stylance-rs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd97877577a015f7055d84843a8dbf69719c8a5277f2f61539eda7d9c025273a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8365afddb71d3920dc993d3b08859299b1b033d5213e64ae636b70d2f2b8bb3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3c814aecc3edfedb4a4b75654da04b03ea83c546432053aa5cadf4b55387f1a"
    sha256 cellar: :any,                 arm64_linux:   "1aa16499efdf33d9d442e45b2e1ef27fc1e7538720a313cd34148479db14681e"
    sha256 cellar: :any,                 x86_64_linux:  "4b507c4ec520eeb06b5032bf473d5fa4f3c588db5aebf2533d9a0dc06e8b9e3e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "stylance-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stylance --version")

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "stylance-test"
      version = "0.1.0"
      edition = "2021"

      [dependencies]
    TOML

    (testpath/"src/button.module.css").write <<~CSS
      .button {
        background-color: blue;
        color: white;
      }
    CSS

    system bin/"stylance", "--output-file", "all.css", testpath
    assert_match "background-color: blue;", (testpath/"all.css").read
  end
end
