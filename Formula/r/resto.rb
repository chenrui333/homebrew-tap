class Resto < Formula
  desc "Send pretty HTTP & API requests with TUI"
  homepage "https://github.com/abdfnx/resto"
  url "https://github.com/abdfnx/resto/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "6d5a1f773b8f21926af786123f436753c80bbea2e2970a96775c4996fd63760a"
  license "MIT"
  head "https://github.com/abdfnx/resto.git", branch: "dev"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version} -X main.versionDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"resto", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resto version")
    output = shell_output("#{bin}/resto settings")
    assert_match "Update Resto settings like enable mouse or change editor theme", output
  end
end
