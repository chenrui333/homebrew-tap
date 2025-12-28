class Timetrace < Formula
  desc "CLI for tracking your working time"
  homepage "https://github.com/dominikbraun/timetrace"
  url "https://github.com/dominikbraun/timetrace/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "670ae0b147ddd6a430efb0a727f1612bcc66fffb025855f151760002c63fb847"
  license "Apache-2.0"
  head "https://github.com/dominikbraun/timetrace.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4423f15766f9c7e37a1c52105159888a1ab7e32775c7499ca64642b24c9bb496"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e2037b663d2620fc6c79edced4aaa445b993ff82131b4e4efe72b782576efd5"
    sha256 cellar: :any_skip_relocation, ventura:       "cba028bf16959201d099ae93bd61b8f7a282efb865d9360c5d47808d2dfd6bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e85f5a0713f7c144ffd7a83d62e7a5116ffec8d899fec1dff96cde75c5b4e6d5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"timetrace", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/timetrace --version")

    assert_match "KEY", shell_output("#{bin}/timetrace list projects")
  end
end
