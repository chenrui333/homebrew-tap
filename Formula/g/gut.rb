class Gut < Formula
  desc "Beginner friendly porcelain for git"
  homepage "https://gut-cli.dev/"
  url "https://github.com/julien040/gut/archive/refs/tags/0.3.1.tar.gz"
  sha256 "6e9f8bed00dcdf6ccb605384cb3b46afea8ad16c8b4a823c0cc631f9e92a9535"
  license "MIT"
  head "https://github.com/julien040/gut.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b34527e00b35f463a2f446eba3fe141b9c8d81e5660f1bf90b0484962e587d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eb9af5cdae874aa73d9b8f7bc1fde63d6f873284c2710eef743853103c6c4ee"
    sha256 cellar: :any_skip_relocation, ventura:       "3cdbced839805f312ff52814264b2ce35d38311efc30888514b9bedea1a9ad9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0387f7fd8b1c32811d28753a93043e1542119e2258252055e15293f5dc01eeb0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/julien040/gut/src/telemetry.gutVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gut", "completion")
  end

  test do
    system bin/"gut", "telemetry", "disable"

    assert_match version.to_s, shell_output("#{bin}/gut --version")

    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "test"
    assert_match "on branch main", shell_output("#{bin}/gut whereami")
  end
end
