class Bearer < Formula
  desc "SAST tool to find, filter, and prioritize code security & privacy risks"
  homepage "https://docs.bearer.com/"
  url "https://github.com/Bearer/bearer/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "3c12db0aef591f8b7f668e244b2b6f3a0c4211f365fdd27960563b38e2ab3773"
  license "Elastic-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b97cd9ffa705e912d51a9691131493802110f9ce651ffda147faefa1ce5edc01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a933e8d706ac88a799027fd800638aa3a593adfbd661c30380d3ac5ba9ea8566"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "781d80a4602e27bdf951406410dc8656e6e5873414c1e50c3da9fd3b6ff0662b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6e7138000ebfb60eb68d7afc9458de0b888d85e196a81880ebd9d9879c31922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01779f1eb1f6aa3ff5e5b3dc0e093b04c9543ea1ba475abddb4287dfaa4aec35"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
