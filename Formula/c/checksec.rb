class Checksec < Formula
  desc "Survey security mitigations used by processes"
  homepage "https://slimm609.github.io/checksec/"
  url "https://github.com/slimm609/checksec/archive/refs/tags/3.2.0.tar.gz"
  sha256 "3ea46986821070ed06fef5215b2a83a9076115a865da70874e19f214db2c8d83"
  license "BSD-3-Clause"
  head "https://github.com/slimm609/checksec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c949bfa6b9a06c2620c7b9357d2249e19632e0fb7f760a1469cf72cb6b0bea55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3a11106e2db557479af0485942a08c44e08a9abe4d7a4138ac69540ae22cca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea6052a421b6e64c3e2a061620e9b51ab64c2f715cd04c3642e25eeb70b61cb3"
    sha256 cellar: :any,                 arm64_linux:   "0afc71c6854db0051759164e0670d8c924d263c3615bf9f4ddff6de5d5719f47"
    sha256 cellar: :any,                 x86_64_linux:  "eb4d81e41567905b565f8fe316dd7b413e87cab91eaeae2ad4f275cee7012344"
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
