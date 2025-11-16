class Yr < Formula
  desc "Get the weather delivered to your command-line"
  homepage "https://git.sr.ht/~timharek/yr"
  url "https://git.sr.ht/~timharek/yr/archive/v1.0.0.tar.gz"
  sha256 "bc8980f06abc23b80fa2e8a8adcfbeeb3fa98b35d4ae883540c9e3c6cb627cba"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~timharek/yr", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/yr"

    generate_completions_from_executable(bin/"yr", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yr --version")

    output = shell_output("#{bin}/yr now nyc")
    assert_match "City of New York", output
  end
end
