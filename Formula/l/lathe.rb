class Lathe < Formula
  desc "Generate hands-on, multi-part technical tutorials on demand"
  homepage "https://github.com/devenjarvis/lathe"
  url "https://github.com/devenjarvis/lathe/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "bd465c7a3f0ee2d60f846f16edeec2488e64120ab45eb3454cf5695556917060"
  license "MIT"
  head "https://github.com/devenjarvis/lathe.git", branch: "main"

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
    assert_match "Generate and manage", shell_output("#{bin}/lathe --help")
  end
end
