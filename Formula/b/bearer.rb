class Bearer < Formula
  desc "SAST tool to find, filter, and prioritize code security & privacy risks"
  homepage "https://docs.bearer.com/"
  url "https://github.com/Bearer/bearer/archive/refs/tags/v1.50.2.tar.gz"
  sha256 "e5b8d0bc52644cb16ea6ee2e628b3064fbb0acc4e52f502e95137bacdde60a67"
  license "Elastic-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd5c93e5f017e0f27671cce10da84fb3e98f1f26a75839a8565d30b101605694"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d440d7fcdb558f58e9823f41d25454ebacd4837955812a2fd874e0157f386b53"
    sha256 cellar: :any_skip_relocation, ventura:       "7833eb0d01bd06d5d35087ff154446cb090881bbe4eb64488997e72ad10b044c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e92b5b9488e884343f25319c676ecb6b5e1b21d622b9e059c9e0494d70f57f66"
  end

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
