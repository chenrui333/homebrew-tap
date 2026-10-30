class Showboat < Formula
  desc "Create executable demo documents that show and prove an agent's work"
  homepage "https://github.com/simonw/showboat"
  url "https://github.com/simonw/showboat/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "4eff24c897df85e383316e3d652c03d17d688df329c4443d2bd70caba277379d"
  license "Apache-2.0"
  head "https://github.com/simonw/showboat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdd614368915d7e07bea11c30727e041aa30b96d92999f17232db20c251ff6a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdd614368915d7e07bea11c30727e041aa30b96d92999f17232db20c251ff6a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4465b6aea8aa740a03b2939df1aa68f082255ff49fc250e9f004fc6034908530"
    sha256 cellar: :any,                 x86_64_linux:  "f9a516e14f655de43167d4e925745c7fde8626fe3b328c08c214952a60cdb77d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/showboat --version")

    system bin/"showboat", "init", "demo.md", "Homebrew demo"
    assert_equal "hello\n", shell_output("#{bin}/showboat exec demo.md sh 'printf \"hello\\n\"'")
    assert_match "hello", (testpath/"demo.md").read
    system bin/"showboat", "verify", "demo.md"
  end
end
