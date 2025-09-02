class Gonzo < Formula
  desc "Powerful, real-time log analysis TUI"
  homepage "https://gonzo.controltheory.com/"
  url "https://github.com/control-theory/gonzo/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "255564415e97322b80db29e947bd8de11699900b9389bfe82f5477973bc011a8"
  license "MIT"
  head "https://github.com/control-theory/gonzo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a46aeea35bbca469b409f0d412ec42deade763d5b833c6e3f76b60e4edddd1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5ff33f3e9e3f69239f4027b0be908398897c765464b7722c7adb20d6b393f64"
    sha256 cellar: :any_skip_relocation, ventura:       "fa2e21adf8e663002021dca83b7ac6f81e9b916a0208a4261e5c142a11e75a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e8712bc8c5a6510c5914890cced5c2d80336df194e976de17f6889106cb66ed"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildTime=#{time.iso8601}
      -X main.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gonzo"

    generate_completions_from_executable(bin/"gonzo", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gonzo --version")

    (testpath/"app.log").write <<~EOS
      2025-09-01T12:00:00Z INFO app started
      2025-09-01T12:01:00Z ERROR failed to connect to db
      2025-09-01T12:02:00Z WARN retrying connection
    EOS
    output = shell_output("#{bin}/gonzo --test-mode -f #{testpath}/app.log")
    assert_match "Test completed successfully", output
  end
end
