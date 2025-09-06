class Urlsup < Formula
  desc "CLI to validate URLs in files"
  homepage "https://github.com/simeg/urlsup"
  url "https://static.crates.io/crates/urlsup/urlsup-2.4.0.crate"
  sha256 "1c41b415e52c84ecf46385c1cb7c2bd54e01846521c4ce2193843aa85edeb0f7"
  license "MIT"
  head "https://github.com/simeg/urlsup.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e2d461463bc66be7fa9572c3f725aa039fa02d359de525c3d3880b89d62a410"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cada3a59279b1d55b0eda1884b682981bc791b82cf2cc26aa44f6d045dc39af"
    sha256 cellar: :any_skip_relocation, ventura:       "a4cb16b0342319f4c070c99ea101618168d7df4d8339cc51d68e09ef44dbd977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ed1573e79f64e4dd36f10abadafa7e40872aea240a32c34a6cdf1c8d8986c1a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/urlsup --version")

    # real link + fake link test
    (testpath/"test.md").write <<~MARKDOWN
      # Test

      - [x] Valid link: https://www.google.com
      - [ ] Invalid link: https://invalid.invalid
    MARKDOWN

    output = shell_output("#{bin}/urlsup #{testpath}/test.md", 1)
    assert_match "ound\e[0m: \e[1m2 unique URLs", output
    assert_match "1. client error (Connect) https://invalid.invalid", output
  end
end
