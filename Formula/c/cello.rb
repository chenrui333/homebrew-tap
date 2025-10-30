class Cello < Formula
  desc "Service for running infrastructure as code software tools"
  homepage "https://github.com/cello-proj/cello"
  url "https://github.com/cello-proj/cello/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "6b471025cfe16385fcdcda495f8d38190c4be05093899e09b88d7ccc68a17142"
  license "Apache-2.0"
  head "https://github.com/cello-proj/cello.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "422613a645f2b02de08a497c3f93936800fbd7e2a01a30005b38eabbd8edb87d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "422613a645f2b02de08a497c3f93936800fbd7e2a01a30005b38eabbd8edb87d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "422613a645f2b02de08a497c3f93936800fbd7e2a01a30005b38eabbd8edb87d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e1dc8444d8f630ed2a7876118453d1740a86b035ae612017507c86374a41b36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e87becda3119e1548d7b5a24f550268c512349ffe74b4739cfda4ebf8ebb8c8b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cli"

    generate_completions_from_executable(bin/"cello", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cello version")

    output = shell_output("#{bin}/cello list --project_name test --target_name test 2>&1", 1)
    assert_match "connection refused", output
  end
end
