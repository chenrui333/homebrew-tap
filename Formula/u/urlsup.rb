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
