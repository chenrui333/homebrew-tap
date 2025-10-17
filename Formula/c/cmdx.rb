# framework: urfave/cli
class Cmdx < Formula
  desc "Task runner"
  homepage "https://github.com/suzuki-shunsuke/cmdx"
  url "https://github.com/suzuki-shunsuke/cmdx/archive/refs/tags/v2.0.2-0.tar.gz"
  sha256 "20f0a5303e8302f9043629d0dc7c06ef4d8eaaafa1700a4dd00b199d9f01d997"
  license "MIT"
  revision 1
  head "https://github.com/suzuki-shunsuke/cmdx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8070db2d69231c60bd650cdf92d8e8cc489d982cf067c1febf732914f3b41ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8070db2d69231c60bd650cdf92d8e8cc489d982cf067c1febf732914f3b41ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8070db2d69231c60bd650cdf92d8e8cc489d982cf067c1febf732914f3b41ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f223d9cbd85dd3f086fdd13daa6228e41bd2cbc5e5c76c5591d76cd7c8a3c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0afa0de5475a9bf27b1317f7875e26edf92cf04c11d5534869bfb92d875cf542"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cmdx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmdx version")

    (testpath/"cmdx.yml").write <<~YAML
      version: 1
      tasks:
        - name: hello
          script: echo "Hello, World!"
    YAML

    output = shell_output("#{bin}/cmdx hello")
    assert_match "Hello, World!", output
  end
end
