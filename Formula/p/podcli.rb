class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.12.0.tar.gz"
  sha256 "068597e14e28868302c03e38eacca64128d73dfa27eaa1c260ca1cfb7e2aec73"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "300de7d9563710867c2cf2f0258c3eb7b606922c6bfc99b0c0e8c6078d9dcc2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "300de7d9563710867c2cf2f0258c3eb7b606922c6bfc99b0c0e8c6078d9dcc2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "300de7d9563710867c2cf2f0258c3eb7b606922c6bfc99b0c0e8c6078d9dcc2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "678a1b95798fa1d651946c0c83d5dcfe49ed0c287b2c8a64eb3e59ccf2c415bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7be8807005493f5686ce2cc351d1b1098e8be045ad5d6223a143074ea282973"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/stefanprodan/podinfo/pkg/version.REVISION=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/podcli"

    generate_completions_from_executable(bin/"podcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/podcli version")

    output = shell_output("#{bin}/podcli check http https://httpbin.org 2>&1")
    assert_match "check succeed", output
  end
end
