class Urlsup < Formula
  desc "CLI to validate URLs in files"
  homepage "https://github.com/simeg/urlsup"
  url "https://static.crates.io/crates/urlsup/urlsup-2.4.0.crate"
  sha256 "1c41b415e52c84ecf46385c1cb7c2bd54e01846521c4ce2193843aa85edeb0f7"
  license "MIT"
  head "https://github.com/simeg/urlsup.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e123fec88cb47f607cef84afe31e830242524dac7c80991661982fbd4a811e09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1e262b2166645f26d4b38156bce8d0214ee3f38b53a5f59c4084592f033542b"
    sha256 cellar: :any,                 arm64_linux:   "18b4386382433af89ca0d051af6204666e2c50254b09b94af67f7a8db5af610e"
    sha256 cellar: :any,                 x86_64_linux:  "b170bb29491b92e9f6b44a823f93078a759c018e95c4ff2c95b9969a9b404f50"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/urlsup --version")

    # URL validation needs external network; check discovery/filtering and local errors instead.
    (testpath/"test.md").write <<~MARKDOWN
      # Test

      - [x] Valid link: https://www.google.com
      - [ ] Invalid link: https://invalid.invalid
    MARKDOWN

    output = shell_output("#{bin}/urlsup #{testpath}/test.md --exclude-pattern google " \
                          "--exclude-pattern 'invalid\\.invalid' --format json --no-progress")
    report = JSON.parse(output)
    assert_equal 1, report.dig("files", "processed")
    assert_equal 0, report.dig("urls", "total_found")
    assert_equal "success", report["status"]

    assert_match "File not found", shell_output("#{bin}/urlsup #{testpath}/missing.md --no-progress 2>&1", 1)
  end
end
