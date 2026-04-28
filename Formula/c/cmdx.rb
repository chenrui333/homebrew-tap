# framework: urfave/cli
class Cmdx < Formula
  desc "Task runner"
  homepage "https://github.com/suzuki-shunsuke/cmdx"
  url "https://github.com/suzuki-shunsuke/cmdx/archive/refs/tags/v2.0.2-0.tar.gz"
  sha256 "20f0a5303e8302f9043629d0dc7c06ef4d8eaaafa1700a4dd00b199d9f01d997"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/cmdx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be5bd263cc9edfe399c4e8fd0540addc74e6bb76bb969eb6b69401c5d73be7c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85ad40ef4ffcd713162749a257f31233376a6cd491dab024fb25ba665627e2a9"
    sha256 cellar: :any_skip_relocation, ventura:       "5ed23451fea9f6bb886a6090a4082bed782ca5cb2b497a17a30626786b3675a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c40b6603ddd407bfef328e7dc65fa14409878bfc24d992c842a42c860895e5f1"
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
