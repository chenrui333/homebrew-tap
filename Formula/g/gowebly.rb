class Gowebly < Formula
  desc "Next-generation CLI tool to easily build amazing web applications"
  homepage "https://gowebly.org/"
  url "https://github.com/gowebly/gowebly/archive/refs/tags/v3.0.6.tar.gz"
  sha256 "6d5292f12855495c369316fd3a9d830715be65f5b7a1762d55f53974dfed0ca6"
  license "Apache-2.0"
  head "https://github.com/gowebly/gowebly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af897b390d3488ddcddec45461973bcd869bc9b1bb42bba571a11b8e5df6d952"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b018a9cc5b5c56caadeb27b0a5d04033993be3d752675b408b1e54d7ea17cae"
    sha256 cellar: :any_skip_relocation, ventura:       "1cbed5ed2542630e88dfc3ebd425f9ad628b3a7ddd14d363261ea63c93d0d134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d17d34bc250cae232adc87ea05d1320127a3632fa5b3f43e2e0ece58d8fd9b60"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowebly doctor")

    output = shell_output("#{bin}/gowebly run 2>&1", 1)
    assert_match "No rule to make target", output
  end
end
