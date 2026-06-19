class Lathe < Formula
  desc "Generate hands-on, multi-part technical tutorials on demand"
  homepage "https://github.com/devenjarvis/lathe"
  url "https://github.com/devenjarvis/lathe/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "4f1ec0c9cb44b240e2fe463d0d4180a85ce4e550ce4e592bdfe8e9ebfa088a92"
  license "MIT"
  head "https://github.com/devenjarvis/lathe.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d55b8ce5cff63dd45ae04f4d4a32973a234e1d09e43a2d8177e4aac6f9e62152"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d55b8ce5cff63dd45ae04f4d4a32973a234e1d09e43a2d8177e4aac6f9e62152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d55b8ce5cff63dd45ae04f4d4a32973a234e1d09e43a2d8177e4aac6f9e62152"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ca684b5ebfee69dc4eea58ba0d1db8c457847e965b89b9e7c8e29c5331e0d05"
    sha256 cellar: :any,                 x86_64_linux:  "5bafff491eb1a1e9d2d15c99fd122fa0ca9f5afbf8c003c8540052c80b2f6600"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devenjarvis/lathe/internal/buildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"lathe", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lathe version")
    output = shell_output("#{bin}/lathe not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
