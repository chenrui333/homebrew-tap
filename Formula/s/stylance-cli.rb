class StylanceCli < Formula
  desc "Scoped CSS style imports for rust"
  homepage "https://github.com/basro/stylance-rs"
  url "https://github.com/basro/stylance-rs/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "d079f160a0b95dd2f801a14c15bfcfba82b4ae3e12d2222dd212ce8f894d2835"
  license "MIT"
  head "https://github.com/basro/stylance-rs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a35c1b8d1cc44e51a8ff2a21038833a75e95407880bf5b2cd1f255c3c60c4a7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efb9e0128095cbe902c6ddc4b3035cc02db74fd675c792dc0e51b42c15dee931"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bba99dfcdbb312976ffbb132355acbb878c820d231fb40f1e2e030695efefd30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "154a6db370b8eacdf73edcb22f162f5dc18c8f7ade117b338620ccc712c82dd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee67d8f7329000ed5f11215bdf660a113fb9ccf47f57a4c4dfd92e6472f762a6"
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
