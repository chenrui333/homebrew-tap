class Lathe < Formula
  desc "Generate hands-on, multi-part technical tutorials on demand"
  homepage "https://github.com/devenjarvis/lathe"
  url "https://github.com/devenjarvis/lathe/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "bd465c7a3f0ee2d60f846f16edeec2488e64120ab45eb3454cf5695556917060"
  license "MIT"
  head "https://github.com/devenjarvis/lathe.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d53c925d7af4c9e0f79033b99737496a8681e6d615c1502dd6255c6822557c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d53c925d7af4c9e0f79033b99737496a8681e6d615c1502dd6255c6822557c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d53c925d7af4c9e0f79033b99737496a8681e6d615c1502dd6255c6822557c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "259ca93eba88cf4702e2df01e208ec478665507e6ba87fa2c95105d15ea0596a"
    sha256 cellar: :any,                 x86_64_linux:  "f02a79fdbab6aa83bf3f015d68e4e779407749b63ebbbc3e1664838945261605"
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
