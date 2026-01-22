class CcFilter < Formula
  desc "Claude Code Sensitive Information Filter"
  homepage "https://github.com/wissem/cc-filter"
  url "https://github.com/wissem/cc-filter/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "ac3844606726dac61c083799b8579b3b97b52059822fe7913401ac08f7db1b4d"
  license "MIT"
  head "https://github.com/wissem/cc-filter.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee4422e99bae2fdcfa771f7b9c2a9aaf32417c709237e9ad3e2e55613d582e12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee4422e99bae2fdcfa771f7b9c2a9aaf32417c709237e9ad3e2e55613d582e12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee4422e99bae2fdcfa771f7b9c2a9aaf32417c709237e9ad3e2e55613d582e12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44ab3fe16fc5b9ea8faf97825f759ddac692ba39b516e93b84b3a90c627c30e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fb9d49ae854f09d0cdb90300edc2e8c9f0abc1abd3767dd2b6d823de4e18c23"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cc-filter --version")

    output = pipe_output("#{bin}/cc-filter", "API_KEY=secret123", 0)
    assert_match "API_KEY=secret123", output
    assert_path_exists testpath/".cc-filter/filter.log"
  end
end
