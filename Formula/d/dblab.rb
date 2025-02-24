class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.danvergara.com/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "7e17c863b3ff1e01bbedbbc421af84fada146648e162d129eaabf9e85485a47d"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

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
