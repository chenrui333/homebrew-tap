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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "718351bf67657ebb73d50126cd6aad42acbf46425d56083b99df4e98629b64c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "718351bf67657ebb73d50126cd6aad42acbf46425d56083b99df4e98629b64c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "718351bf67657ebb73d50126cd6aad42acbf46425d56083b99df4e98629b64c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abf57e82d3bf00b073f681a7ae6d6c89f07ced615549944f929e503e2aaf476d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f587d11bbcc7611e5d4c90deddce11e91bcd5724248f137010f6e3d3020687c5"
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
