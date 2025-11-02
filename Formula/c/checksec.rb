class Checksec < Formula
  desc "Survey security mitigations used by processes"
  homepage "https://slimm609.github.io/checksec/"
  url "https://github.com/slimm609/checksec/archive/refs/tags/3.0.2.tar.gz"
  sha256 "01b854ead73a2892385fae52fe80b8f61411c19e33cf87d7e5633a9af6cae052"
  license "BSD-3-Clause"
  head "https://github.com/slimm609/checksec.git", branch: "main"

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

    output = shell_output("#{bin}/checksec file #{bin}/checksec 2>&1", 1)
    assert_match "File is not an ELF file", output
  end
end
