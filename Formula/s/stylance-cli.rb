class StylanceCli < Formula
  desc "Scoped CSS style imports for rust"
  homepage "https://github.com/basro/stylance-rs"
  url "https://github.com/basro/stylance-rs/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "e36485a3e41171c0af6c1cfe485e830587ec90a0929f4ffdf3d6a84194aa3dbf"
  license "MIT"
  head "https://github.com/basro/stylance-rs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06f328bd079643ccce8cb4d40927c9db1bef378fb82e23b5cdcab36bd7566eb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26962a7b8ed0c7b80df3292b140fbdc9451c12866483c4f8f97a04eacde12971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44b6d61ce08af28d961dbeff5e797b407009454b14555db74c006439450724a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a147fc3a3b51fcf40bf7ba62d3aa4bb2a979471645d8f50a4bf513366a44d5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61fb293a23cc684440698d1462fd7f703f13b57de26506af1f20b5fa6ef9895e"
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
