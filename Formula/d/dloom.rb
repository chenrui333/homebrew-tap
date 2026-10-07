class Dloom < Formula
  desc "Dotfile and configuration weaver tool"
  homepage "https://github.com/dloomorg/dloom"
  url "https://github.com/dloomorg/dloom/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "75035d1f5eb1de02a8242fc7a259099be47ac8703a654a11c9b6ce4d3131c2e5"
  license "MIT"
  head "https://github.com/dloomorg/dloom.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "535df41e762771b824660223f3b1c621d1013cf0788d5adc74e39fc3d0cd42c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "535df41e762771b824660223f3b1c621d1013cf0788d5adc74e39fc3d0cd42c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d0e1efd59942d4ef8de3191e9b05d7c07cd8abd5176cd2f14f8319376227afa"
    sha256 cellar: :any,                 x86_64_linux:  "2013e47953c250de4af5f03b9ba01505846dc27ad212f3156efbf6e68582a820"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/dloomorg/dloom/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"dloom", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dloom version")

    (testpath/"dloom").mkpath
    (testpath/"dloom/config.yaml").write <<~YAML
      version: 0.0.1
    YAML
    assert_match "Would run script: bootstrap", shell_output("#{bin}/dloom --dry-run setup bootstrap")
  end
end
