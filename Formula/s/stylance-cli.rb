class StylanceCli < Formula
  desc "Scoped CSS style imports for rust"
  homepage "https://github.com/basro/stylance-rs"
  url "https://github.com/basro/stylance-rs/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "4895bdd41379dbfe1166eba513a69186946abe8f5fab1fa0d269131e2bc1efbb"
  license "MIT"
  head "https://github.com/basro/stylance-rs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c3864d2d64886840e562d8d46c7b245f48c0353db652e85e21f08042f2f2e69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c77bdbe28f7c1176f2119bad34a83efcd50c85a24905e4ad5ff37149a3777e97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7825c623a735c51e13ee9fd22550d54a1d440cfa10b3e1fdb588cc2b7c3d493b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "015b7e2173b03993f66225db0aa3a35ecea41224ec1107bb9a7ff39fb4726dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9595f9aac7209699fbdfddf2b18a4ab2c70f2621abb2caf64bff708c56833ee6"
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
