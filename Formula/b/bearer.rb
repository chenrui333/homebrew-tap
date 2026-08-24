class Bearer < Formula
  desc "SAST tool to find, filter, and prioritize code security & privacy risks"
  homepage "https://docs.bearer.com/"
  url "https://github.com/Bearer/bearer/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "3c12db0aef591f8b7f668e244b2b6f3a0c4211f365fdd27960563b38e2ab3773"
  license "Elastic-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb8741cea0b80f65feef687d5a1bc2728b23ae4ecc6d9c645b1bfa0482eff72a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4fa7947e3b7b4c0df4fd1a2f4eda82a3b7e213d9bc1279ae588d5ebf0432178"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82a20a64e6ebd4b09e7959d6cbb4e24fca9c43de95b8919fd8a9be772ad83711"
    sha256 cellar: :any,                 arm64_linux:   "174fa6b6a5c0d4fbb5a4908b87a101de838634ee356bee34a2358e8c7e9800cc"
    sha256 cellar: :any,                 x86_64_linux:  "29396bf6d76817a1ddb18cea14b5a5b5b1daeb8863afa698b32395e4aee61b63"
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
