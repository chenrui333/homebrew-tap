class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.104.tar.gz"
  sha256 "3500ebfa6e679cdf4e885e3b99db48dd86ea62732f1fc5879cfd426edb3156e7"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1e7eb27b1a54da4001a552ed570424a8f62673b7929fff226ca0ebe94c04b1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1e7eb27b1a54da4001a552ed570424a8f62673b7929fff226ca0ebe94c04b1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1e7eb27b1a54da4001a552ed570424a8f62673b7929fff226ca0ebe94c04b1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a1c28fa60de5221cf99ff783deaafc8a7069f58c974c0a9fe5c4a929695f211"
    sha256 cellar: :any,                 x86_64_linux:  "72a621890697fd0274e7a6a810344430c8b8bf1683877e07e01a1e12a6b69976"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
