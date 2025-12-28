class Cello < Formula
  desc "Service for running infrastructure as code software tools"
  homepage "https://github.com/cello-proj/cello"
  url "https://github.com/cello-proj/cello/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "6b471025cfe16385fcdcda495f8d38190c4be05093899e09b88d7ccc68a17142"
  license "Apache-2.0"
  head "https://github.com/cello-proj/cello.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27a94d9100cf9d243c0eff3cc7e8bf2e0ef970006561e85393a6a7c13b5e1fcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27a94d9100cf9d243c0eff3cc7e8bf2e0ef970006561e85393a6a7c13b5e1fcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27a94d9100cf9d243c0eff3cc7e8bf2e0ef970006561e85393a6a7c13b5e1fcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6e45f0a4399cea6b9f7577ee5db0b146c64297a994d320bd7f6a5fd93e2e31c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1b34518c71f7022b145cad5cdcf89161db41ae1c1d8fcd56eaad40157203678"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cli"

    generate_completions_from_executable(bin/"cello", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cello version")

    output = shell_output("#{bin}/cello list --project_name test --target_name test 2>&1", 1)
    assert_match "connection refused", output
  end
end
