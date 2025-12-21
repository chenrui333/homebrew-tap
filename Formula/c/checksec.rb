class Checksec < Formula
  desc "Survey security mitigations used by processes"
  homepage "https://slimm609.github.io/checksec/"
  url "https://github.com/slimm609/checksec/archive/refs/tags/3.1.0.tar.gz"
  sha256 "cd3112fb02577726dd6945a11d9225d508ac0d59984d772fbbda5d9cf2d2c290"
  license "BSD-3-Clause"
  head "https://github.com/slimm609/checksec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dea3c01be687c175ff5fd2f2027aa260a06f523c8c7c8bb8418a3db71fdcd3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0be385e65082ffecfae1844e74cd23ac8e3d3111db682b91b0e34b65ac35a9f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3d243fd1b211afc86cd4a861d818b2231b3fdfbcb93f380160a95f9351edfd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3faaeda0e1ca2a11dc6a29ee9e2f9548749d261f6a4f6643b1453e4b3c75f87e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d76a40c42c0cbc6ee097b48db18e27c57330d123b654e5aca2cd6fac7158c03"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    # Workaround to avoid patchelf corruption when cgo is required (for go-zetasql)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"checksec", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/checksec --version")

    if OS.mac?
      output = shell_output("#{bin}/checksec file #{bin}/checksec 2>&1", 1)
      assert_match "File is not an ELF file", output
    else
      expected = (Hardware::CPU.arch == :arm64) ? "PIE Enabled" : "PIE Disabled"
      assert_match expected, shell_output("#{bin}/checksec file #{bin}/checksec")
    end
  end
end
