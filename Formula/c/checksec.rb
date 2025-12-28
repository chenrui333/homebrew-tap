class Checksec < Formula
  desc "Survey security mitigations used by processes"
  homepage "https://slimm609.github.io/checksec/"
  url "https://github.com/slimm609/checksec/archive/refs/tags/3.1.0.tar.gz"
  sha256 "cd3112fb02577726dd6945a11d9225d508ac0d59984d772fbbda5d9cf2d2c290"
  license "BSD-3-Clause"
  head "https://github.com/slimm609/checksec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "993131876eef90a8c62834707ecec1aabf129b1ac917226dda2dfc9368b0df80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cae962674fa2917ba5b5feb4dbb71c1874e1700713838367c8f2687c3bcef05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "404f94518d6a91da817e8fd7d50fd3b0d0822ea3697314ca0f278af9789e998d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "713cf28b0ef8b4f8b9e7dba2d6d1ba0da9bf8aef99a212e57f6b1b44cbd88c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc18ac82fccd7281fdb7ca2ddfe9a0955fc4256c665e744db19bb0c709a1cadd"
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
