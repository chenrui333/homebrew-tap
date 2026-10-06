class Snitch < Formula
  desc "SNI-based host discovery tool for TLS layer reconnaissance"
  homepage "https://github.com/cirosec/SNItch"
  url "https://github.com/cirosec/SNItch/archive/refs/tags/v1.3-public.tar.gz"
  sha256 "16374f63e97bb9feb25026087a27f1b444aa254d406bb042f6d4ddd59c739036"
  license "AGPL-3.0-only"
  head "https://github.com/cirosec/SNItch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a38dcb7c8c621aac4cf2bb3250e6b50ab615efd8b8bb4c7010959de5cad617ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a38dcb7c8c621aac4cf2bb3250e6b50ab615efd8b8bb4c7010959de5cad617ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03a6aa304dc7068c6ac61188a956d182bfc67db2af36afeff8ffe19e2f2de6b8"
    sha256 cellar: :any,                 x86_64_linux:  "63b5dc2c5be3d2aae64c1a791ce734c41afe247b131400c5fd6a283dd02eb858"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["GOTOOLCHAIN"] = "local"

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}")
    generate_completions_from_executable(bin/"snitch", shell_parameter_format: :cobra)
  end

  test do
    assert_match "SNItch version #{version}", shell_output("#{bin}/snitch --version")

    output = shell_output(bin/"snitch")
    assert_match "No targets or hosts found.", output
    assert_match "Provide targets as positional argument", output
  end
end
