class StylanceCli < Formula
  desc "Scoped CSS style imports for rust"
  homepage "https://github.com/basro/stylance-rs"
  url "https://github.com/basro/stylance-rs/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3c47cdd2222c05da09fbc333e74ea1c04d63d5a3368fc7b2e225daa4be4a6e72"
  license "MIT"
  head "https://github.com/basro/stylance-rs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91a8d3cb21fdc188ef915c49f1b2197906918c143f4957d0751b353b1c531c5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18cc5fd5899cd7dad6d096b1b43ecd09986ae36fd677c332d8d3237eac208b32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1d285ec4db17f4249c2d04b074628990ee087f5bf3191e51ddaf65eaa3f678e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9098c604ae476caabc25a1490d16ac4ffb7fbedeb0f77bf283cf23cc2cb4caec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "588dfa581057f1d5d4bbb16ec17835246561ab24c4e20d948c5a64a48576761e"
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
