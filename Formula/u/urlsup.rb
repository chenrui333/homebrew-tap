class Urlsup < Formula
  desc "CLI to validate URLs in files"
  homepage "https://github.com/simeg/urlsup"
  url "https://static.crates.io/crates/urlsup/urlsup-2.4.0.crate"
  sha256 "1c41b415e52c84ecf46385c1cb7c2bd54e01846521c4ce2193843aa85edeb0f7"
  license "MIT"
  head "https://github.com/simeg/urlsup.git", branch: "master"

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
