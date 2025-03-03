class Timetrace < Formula
  desc "CLI for tracking your working time"
  homepage "https://github.com/dominikbraun/timetrace"
  url "https://github.com/dominikbraun/timetrace/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "670ae0b147ddd6a430efb0a727f1612bcc66fffb025855f151760002c63fb847"
  license "Apache-2.0"
  head "https://github.com/dominikbraun/timetrace.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"timetrace", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/timetrace --version")

    assert_match "KEY", shell_output("#{bin}/timetrace list projects")
  end
end
