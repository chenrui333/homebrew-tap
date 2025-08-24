class Bearer < Formula
  desc "SAST tool to find, filter, and prioritize code security & privacy risks"
  homepage "https://docs.bearer.com/"
  url "https://github.com/Bearer/bearer/archive/refs/tags/v1.50.2.tar.gz"
  sha256 "e5b8d0bc52644cb16ea6ee2e628b3064fbb0acc4e52f502e95137bacdde60a67"
  license "Elastic-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/bearer/bearer/cmd/bearer/build.Version=#{version}
      -X github.com/bearer/bearer/cmd/bearer/build.CommitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bearer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bearer version 2>&1")

    (testpath/"test.js").write <<~JS
      const password = "this is my password";
      console.log(password);
    JS
    output = shell_output("#{bin}/bearer scan #{testpath}/test.js 2>&1", 1)
    assert_match "CRITICAL: Usage of hard-coded secret [CWE-798]", output
  end
end
