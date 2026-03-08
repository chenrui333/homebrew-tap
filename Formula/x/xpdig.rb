class Xpdig < Formula
  desc "Dig into Crossplane traces via TUI"
  homepage "https://github.com/brunoluiz/xpdig"
  url "https://github.com/brunoluiz/xpdig/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "cf339d528910118625a79c430ea838404f746b8d9cbeb363ec6ddfa052de6d40"
  license "Apache-2.0"
  head "https://github.com/brunoluiz/xpdig.git", branch: "main"

  depends_on "go" => :build
  depends_on "crossplane"

  def install
    ENV["CGO_ENABLED"] = "1"

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/xpdig"
  end

  test do
    version_output = shell_output("#{bin}/xpdig version")
    assert_match version.to_s, version_output

    # Concrete negative-path command to prove the binary handles bad input cleanly.
    invalid_output = shell_output("#{bin}/xpdig not-a-real-command 2>&1", 3)
    assert_match "No help topic for 'not-a-real-command'", invalid_output
    refute_match "panic:", invalid_output
  end
end
