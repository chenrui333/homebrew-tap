class Claws < Formula
  desc "Terminal UI for AWS resource management"
  homepage "https://github.com/clawscli/claws"
  url "https://github.com/clawscli/claws/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "ff31632a919005ef694e63e7070b9f70fd01900b8c7e1059c1d69b0b489dd53f"
  license "Apache-2.0"
  head "https://github.com/clawscli/claws.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "643fe4fd2f90a8ec0af9d783a8be5fa47e6bb7d64548f84d980e78e081100d3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "643fe4fd2f90a8ec0af9d783a8be5fa47e6bb7d64548f84d980e78e081100d3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "643fe4fd2f90a8ec0af9d783a8be5fa47e6bb7d64548f84d980e78e081100d3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8370fc1d5d2e306ea3269d0190af0532f4cbc96bf45576e96cd4da94c1338b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f0e62d601482d63b2af6425ce03d90dca816e79e92943057359f97a9bc3b972"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"claws"), "./cmd/claws"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claws --version")

    output = shell_output("#{bin}/claws --profile invalid/name 2>&1", 1)
    assert_match "Error: invalid profile name: invalid/name", output
    assert_match "Valid characters: alphanumeric, hyphen, underscore, period", output
  end
end
