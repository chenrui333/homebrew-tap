class Hishtory < Formula
  desc "Your shell history: synced, queryable, and in context"
  homepage "https://hishtory.dev"
  url "https://github.com/ddworken/hishtory/archive/refs/tags/v0.335.tar.gz"
  sha256 "f312acc99195ca035db7b6612408169ce3a14c170f85dba238f9a29ca7825a3d"
  license "MIT"
  head "https://github.com/ddworken/hishtory.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8186db02f74066e8431ad56527a414e2403e03aadf3a97271460d3f9ea4dfda0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c281b2f82665fe0ecf705b50de3d99e8bfecaf01edc44b945fbcfa0a9f76e367"
    sha256 cellar: :any_skip_relocation, ventura:       "ac86ebd114eac5c0ebcaa5b99544d3067963de8f64879de33106152c2f6cec4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "105c8ce9fa195488f8469d14ae9c68dc698d791154936ed539dd59010d309070"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ddworken/hishtory/client/lib.Version=#{version}
      -X github.com/ddworken/hishtory/client/lib.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hishtory", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hishtory --version")

    output = shell_output("#{bin}/hishtory init")
    assert_match "Setting secret hishtory key", output

    assert_match "Enabled: true", shell_output("#{bin}/hishtory status")
  end
end
