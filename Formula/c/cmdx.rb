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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a764e0d086c221599bf29b5d5b3102ed3eb6f10768c6ea96679f8bb27d9a554e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "878d78f0754c20c11f6233b1680d1e9a96937bf717645bcdaded1022510bfd44"
    sha256 cellar: :any_skip_relocation, ventura:       "3b4245b56eab31b0c9b9b3dd23cb29f6043867cfdae344537c1492cd84b11499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9baaa95151bff3b5034374f007c075ee66c31cddc00967632f97a30bf27fbf6"
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
