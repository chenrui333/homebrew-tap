class Lathe < Formula
  desc "Generate hands-on, multi-part technical tutorials on demand"
  homepage "https://github.com/devenjarvis/lathe"
  url "https://github.com/devenjarvis/lathe/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "bd465c7a3f0ee2d60f846f16edeec2488e64120ab45eb3454cf5695556917060"
  license "MIT"
  head "https://github.com/devenjarvis/lathe.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89797f577028ffabc9deef8ec4ff4cb19c4ba1954a5fc151f3c5c849791473e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89797f577028ffabc9deef8ec4ff4cb19c4ba1954a5fc151f3c5c849791473e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89797f577028ffabc9deef8ec4ff4cb19c4ba1954a5fc151f3c5c849791473e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0876e40bdfc8e27a5e51d52f89302c8d093db5814392e22eadecf98b7ac9db3"
    sha256 cellar: :any,                 x86_64_linux:  "d513785a520a18d4bb8b22b093a0cbd6c0c7451b07fc2fb7f814eb7477a692e6"
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
    assert_match "Generate and manage", shell_output("#{bin}/lathe --help")
  end
end
