# framework: urfave/cli
class Cmdx < Formula
  desc "Task runner"
  homepage "https://github.com/suzuki-shunsuke/cmdx"
  url "https://github.com/suzuki-shunsuke/cmdx/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "69e16605ff3ae0196ca5ce1ab27ae4de789855de358e30ff18d1a613f2145e2c"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/cmdx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dce55adb17d26127a245e6d652138fce663f0e20dd2cb3e8af7d53a0647b743f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa89947e2f2d173889f56ab9d6df532606fc9de692e3f5bbc416dadc35fc5745"
    sha256 cellar: :any_skip_relocation, ventura:       "db0809cc4b208c0018a944ebd593005ec89a74488f68ff7dc13efc427ba3eba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16acbabedf6e135e5db5385aab31a296d230aa1c79d1fc18c965d112aedea6a1"
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
