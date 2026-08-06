class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "2aadc52c2883b7b0d2e33468b28f94232ce1d0688b96fcb7e4b926841f157b88"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7038b9ab32479149d292d84ddf2158e1863ca5a1b23fafeb4e194701cbee69bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7038b9ab32479149d292d84ddf2158e1863ca5a1b23fafeb4e194701cbee69bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7038b9ab32479149d292d84ddf2158e1863ca5a1b23fafeb4e194701cbee69bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad8522004f089e1e40067a9cf54ed7a78c6f2eb38f66599f7524d57025d6e498"
    sha256 cellar: :any,                 x86_64_linux:  "07acd679637697749edac6a228443e74c33a616ba40a7abb31469439213901fc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    output = shell_output("#{bin}/lfk not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
