class Checksec < Formula
  desc "Survey security mitigations used by processes"
  homepage "https://slimm609.github.io/checksec/"
  url "https://github.com/slimm609/checksec/archive/refs/tags/3.1.0.tar.gz"
  sha256 "cd3112fb02577726dd6945a11d9225d508ac0d59984d772fbbda5d9cf2d2c290"
  license "BSD-3-Clause"
  head "https://github.com/slimm609/checksec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a948d4ea23454cfe9b577afee433ab4b6f30fcc7d3c04da472d28e4aac5d8b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50044c6e6ff760a6510076305f2b1ba8230c338e2c6877b172af5c70a003cb81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00f09c0ee43b03b9ab1ea55d6024024eed3af379ac6e31b65871d6da6120dc3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3712996861760cad5d65faa79dbaeb6bcf5da3e0862ca2f4ea0d855d530e8753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e14e9dd4cc3720d03689806728b18933be83611df5b7763d1db70fbd18ddcc9"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    # Workaround to avoid patchelf corruption when cgo is required (for go-zetasql)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"checksec", shell_parameter_format: :cobra)
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
