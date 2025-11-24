class StylanceCli < Formula
  desc "Scoped CSS style imports for rust"
  homepage "https://github.com/basro/stylance-rs"
  url "https://github.com/basro/stylance-rs/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "e36485a3e41171c0af6c1cfe485e830587ec90a0929f4ffdf3d6a84194aa3dbf"
  license "MIT"
  head "https://github.com/basro/stylance-rs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f10e3e30bb52fb8968f2fbbadf1565cfd8830b93889fa7d2859fd019bef63655"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea3d8d4b3f62a9e962e6a90720a0086143a03bbef992bba6228a4659cedd01e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16e2d3f89080628110958713c7319519c7a6c93af28746fa94927e37d14ed8b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77773a3a50ba4ffe576b2c95f5b7ce9b3ba77db1567e600b4a0a38112a963eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29511dbac7fd9d401a99dae34895475ca8844ddcbf18e0a1c402d30563c118d3"
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
