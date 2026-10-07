class Toolctl < Formula
  desc "Tool to control your tools"
  homepage "https://github.com/toolctl/toolctl"
  url "https://github.com/toolctl/toolctl/archive/refs/tags/v0.4.17.tar.gz"
  sha256 "6b2e2f208f34ceeb0c9c88edda45d372f41886dfe00133880ed5626064676778"
  license "MIT"
  head "https://github.com/toolctl/toolctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e82fcd6a38390b16d37b3c4760c7f787770c667f19ba99e17277c18f27c0476b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e82fcd6a38390b16d37b3c4760c7f787770c667f19ba99e17277c18f27c0476b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6770ea8c1e3ae2f103562a8523279b36038a51c30b9a39820d67a65a5856152"
    sha256 cellar: :any,                 x86_64_linux:  "d82ee1713adad389844efc87d3d0c9361cf0887fed2aa1346690fd21efb68306"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/toolctl/toolctl/internal/cmd.gitVersion=#{version}
      -X github.com/toolctl/toolctl/internal/cmd.gitCommit=#{tap.user}
      -X github.com/toolctl/toolctl/internal/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"toolctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toolctl --version")

    # Serve tool metadata from the hidden local API instead of raw.githubusercontent.com.
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    (testpath/"api/meta.yaml").write <<~YAML
      tools:
        - toolctl
    YAML
    (testpath/"api/toolctl/meta.yaml").write <<~YAML
      description: The tool to control your tools
      homepage: https://github.com/toolctl/toolctl
      downloadURLTemplate: https://example.com/{{.Version}}
      versionArgs: [--version]
    YAML
    (testpath/"api/toolctl/#{os}-#{arch}/meta.yaml").write <<~YAML
      version:
        earliest: 0.1.0
        latest: #{version}
    YAML
    (testpath/"config.yaml").write "LocalAPIBasePath: #{testpath}/api\n"

    args = ["--local", "--config", testpath/"config.yaml"]
    assert_match "toolctl", shell_output("#{bin}/toolctl list --all #{args.join(" ")}")
    output = shell_output("#{bin}/toolctl info toolctl #{args.join(" ")}")
    assert_match "toolctl v#{version}: The tool to control your tools", output
  end
end
