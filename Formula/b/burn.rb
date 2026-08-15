class Burn < Formula
  desc "See what's burning your Kubernetes budget"
  homepage "https://github.com/tanrikuluozlem/burn"
  url "https://github.com/tanrikuluozlem/burn/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "6f8472105e277837ac012daf1fb59e650c5e973f4eb498f65dd986865e291f42"
  license "Apache-2.0"
  head "https://github.com/tanrikuluozlem/burn.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e45d97bd0fcf27ed831c00e0f24516d1abba0e5df26aa6e0f5eef20e0c99eab0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e45d97bd0fcf27ed831c00e0f24516d1abba0e5df26aa6e0f5eef20e0c99eab0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e45d97bd0fcf27ed831c00e0f24516d1abba0e5df26aa6e0f5eef20e0c99eab0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad3a16af4222a12475ba790bee1344211a3ba970cccd7058900007a447026673"
    sha256 cellar: :any,                 x86_64_linux:  "986c68a51ad2633d22ff57257e0af47361dac176d47d6f99d6a9d0c8684a14ed"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/burn"

    generate_completions_from_executable(bin/"burn", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/burn version")

    output = shell_output("#{bin}/burn analyze --ai 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
