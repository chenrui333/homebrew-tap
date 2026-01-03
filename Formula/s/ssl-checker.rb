class SslChecker < Formula
  desc "Fast and beautiful program to check all your https endpoints"
  homepage "https://github.com/fabio42/ssl-checker"
  url "https://github.com/fabio42/ssl-checker/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "a29d9ff77be95acbc4e1100b6e0dce867f5554d9bd3f0ae7bbc4a8c825f07ec8"
  license "MIT"
  head "https://github.com/fabio42/ssl-checker.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "570e8ddea6d822360174865d1d2dae830054748b37e9071befbc64fc3ed0390d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "570e8ddea6d822360174865d1d2dae830054748b37e9071befbc64fc3ed0390d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "570e8ddea6d822360174865d1d2dae830054748b37e9071befbc64fc3ed0390d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7066294abb13e11a9b34b6ea2ddf8b75634469070c463da3f93ae376a06fb4e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcc0092f86d538a292140dd6d6adff7193bad83fe4a2fd9d68274b913baf9f30"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/fabio42/ssl-checker/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ssl-checker", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ssl-checker --version")

    # failed with Linux CI, `/dev/tty: no such device or address` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/ssl-checker domains example.com --silent")
    assert_match "CN=DigiCert Global G3 TLS ECC SHA384 2020 CA1,O=DigiCert Inc,C=US", output
  end
end
