class StylanceCli < Formula
  desc "Scoped CSS style imports for rust"
  homepage "https://github.com/basro/stylance-rs"
  url "https://github.com/basro/stylance-rs/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "3f059f07d321e65ea301f0c27947230f4c8eb196c0e15e620d180c3af6535fd7"
  license "MIT"
  head "https://github.com/basro/stylance-rs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82641aeacf729febadd40f706ffdcd1b7326c52e35e69a7538f92287c2f2ed58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad739d9c4a081d267122e4362dc9825212ab8043c4ec24e302c90e4961c299ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abfd13a6d0c8a925e79e22844a548016b70dddbe3672787974efa3dfae635440"
    sha256 cellar: :any,                 arm64_linux:   "ff983785da8d72898c1f845050272e49852d3c3fb8273c3f6e09488e69717423"
    sha256 cellar: :any,                 x86_64_linux:  "ed6fede4f39fb38b4fef69dec1543b5804552ba50318c6b9fbed59a475cfdce0"
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
