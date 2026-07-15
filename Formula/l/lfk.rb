class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.15.8.tar.gz"
  sha256 "a1bfcfbfd3951dec5db6a68a7b4523e78be8dfb5ea4b48fc23e8e12b6d33daa0"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9db802264bdfa6a2cb6970c31abe49461c526e255449ab6ca45082c349e59fc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9db802264bdfa6a2cb6970c31abe49461c526e255449ab6ca45082c349e59fc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9db802264bdfa6a2cb6970c31abe49461c526e255449ab6ca45082c349e59fc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28dfb075b7f9632c2c33963e9fdc773945c514ac21b29a6a103fc4280eb6e0ff"
    sha256 cellar: :any,                 x86_64_linux:  "7bd51a29870882f73d5adfe8ceff2bcce413762b6406e64eb28924b2955378e3"
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
