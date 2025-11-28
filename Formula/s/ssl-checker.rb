class SslChecker < Formula
  desc "Fast and beautiful program to check all your https endpoint"
  homepage "https://github.com/fabio42/ssl-checker"
  url "https://github.com/fabio42/ssl-checker/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "a29d9ff77be95acbc4e1100b6e0dce867f5554d9bd3f0ae7bbc4a8c825f07ec8"
  license "MIT"
  head "https://github.com/fabio42/ssl-checker.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/fabio42/ssl-checker/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ssl-checker", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ssl-checker --version")

    output = shell_output("#{bin}/ssl-checker domains example.com --silent")
    assert_match "CN=DigiCert Global G3 TLS ECC SHA384 2020 CA1,O=DigiCert Inc,C=US", output
  end
end
