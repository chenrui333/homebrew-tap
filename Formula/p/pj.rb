class Pj < Formula
  desc "Fast project directory finder"
  homepage "https://github.com/josephschmitt/pj"
  url "https://github.com/josephschmitt/pj/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "7c08277c6cae5c5193400c2fbe2f2b87a68c79502278e088285ec45abe2b1bd5"
  license "MIT"
  head "https://github.com/josephschmitt/pj.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8984cd3edfa5bb6737871037359ded639519f687a30602269052cc464db9ea4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8984cd3edfa5bb6737871037359ded639519f687a30602269052cc464db9ea4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15310659359c3977859b1b2e2ea4db6ceda70a9d9ef89a2193364f9215af45b1"
    sha256 cellar: :any,                 x86_64_linux:  "8decc793e54c75b1e4c54ead0d2c8fd2d9efd36739b29bd33e8f36c049b929a7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"demo").mkpath
    (testpath/"demo/go.mod").write <<~EOS
      module example.com/demo

      go 1.22
    EOS

    output = shell_output(
      "#{bin}/pj --path #{testpath} --marker go.mod --max-depth 2 --no-cache --format %P",
    )
    assert_equal "#{testpath}/demo\n", output
    assert_match version.to_s, shell_output("#{bin}/pj --version")
  end
end
