# framework: cobra
class Surgeon < Formula
  desc "Surgically modify a fork"
  homepage "https://github.com/bketelsen/surgeon"
  url "https://github.com/bketelsen/surgeon/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "d769bbb4640965c14eb00952f337d65f39c62886920d2171cc8b168abe4da9fd"
  license "MIT"
  head "https://github.com/bketelsen/surgeon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65dc89405911ee78f6cb83c4e12a26106e489d894e15a50423ac0bee28200f48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6a0197af8f6d87541668f951d4b42cacbe1e96a98547d0c5fe55e0e48a32b9e"
    sha256 cellar: :any_skip_relocation, ventura:       "387a058815da8b64988151166671b016e1977665d7c8a50759e55f717de01659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a10d0686417f9a5ccc3aa9ef67f2c36cb5a264e8815edceb10f7890e9796400d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X main.treeState=clean
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/surgeon"

    generate_completions_from_executable(bin/"surgeon", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surgeon --version")

    system bin/"surgeon", "init"
    assert_match "description: Modify URLS", (testpath/".surgeon.yaml").read
  end
end
