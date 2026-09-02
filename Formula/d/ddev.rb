class Ddev < Formula
  desc "Docker-based local PHP+Node.js web development environments"
  homepage "https://ddev.com/"
  url "https://github.com/ddev/ddev/archive/refs/tags/v1.25.4.tar.gz"
  sha256 "aa5de78b4303ffbe7d11d522ebc143de7aa47b43c308383d14509cea602a13f6"
  license "Apache-2.0"
  head "https://github.com/ddev/ddev.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "226b7fe55ce9fcf0b877b5d5ff5e82dfe2355eeeb5aae3b9d835e8d1fe8bdee0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "226b7fe55ce9fcf0b877b5d5ff5e82dfe2355eeeb5aae3b9d835e8d1fe8bdee0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "226b7fe55ce9fcf0b877b5d5ff5e82dfe2355eeeb5aae3b9d835e8d1fe8bdee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5145d28414670e5af5dcb4f07ec0c18cd3851a79fcf94533847065d2d764e042"
    sha256 cellar: :any,                 x86_64_linux:  "ec848f965ad16f1a6bacd110451f38fc0abc50bc87d77e1518b7b89b5c7614ad"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = "-s -w -X github.com/ddev/ddev/pkg/versionconstants.DdevVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ddev"

    # generate_completions_from_executable(bin/"ddev", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/ddev --version")

    assert_match "failed to connect to the docker API", shell_output("#{bin}/ddev list 2>&1", 1)
  end
end
