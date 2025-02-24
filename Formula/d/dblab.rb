class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.danvergara.com/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "7e17c863b3ff1e01bbedbbc421af84fada146648e162d129eaabf9e85485a47d"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c67d5ea7906af3e085347b9c58de8abe22e45c8fd0b1c74f4218188d3aa22134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73f9a10916dfb32b13a614f0f12cfdbbd33fb3d6e8af675bcc6f5e1266856b47"
    sha256 cellar: :any_skip_relocation, ventura:       "14fdee29e2611af2d6ac2c7cbebe3e985f19f5154e4d5c74b1174471ddbcf639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8948f8d13030435468b83ab6d09c3048013ec8bf9a806fc6072763a55da8e8fa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
