# framework: urfave/cli
class Cmdx < Formula
  desc "Task runner"
  homepage "https://github.com/suzuki-shunsuke/cmdx"
  url "https://github.com/suzuki-shunsuke/cmdx/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "22fea7d5b221a3863a6dfd88d949ef499a112c692b9511fbadfe6aa7127a95fc"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/cmdx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "422b6f6e23888ae52e4bfe326a4ef26108bd7b3a428aeeea241abc8f524980d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1da34e67fa53862f3ab4ee21de6984d9310ca9d1ca59f9aca5c79ff64fa9100"
    sha256 cellar: :any_skip_relocation, ventura:       "6128f4821cbebfb039178beb8fd7dfc09a820f1553215bc41bfcfa9e9936713f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17295cc7c7b4b4876619ecc4ef529907a5eb6983e06c9c91c5bf621a24e289f5"
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
