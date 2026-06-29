class Dgop < Formula
  desc "API & CLI for System & Process Monitoring"
  homepage "https://danklinux.com/"
  url "https://github.com/AvengeMedia/dgop/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "afd2f9542ce25c739b13d6213fdfbc5493bce537d5afec309b4df945e318ff1a"
  license "MIT"
  head "https://github.com/AvengeMedia/dgop.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "53047dfabf7db803b87fd16d405d152c42f4cf70dab2fa33faded4c6e137fca6"
    sha256 cellar: :any,                 x86_64_linux: "3d56b37f9eb22a0f77bd09cf67b81b2edc5724809c1132df8844aedc1b398e56"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.buildTime=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dgop"

    generate_completions_from_executable(
      bin/"dgop", shell_parameter_format: :cobra, shells: [:bash, :zsh, :fish, :pwsh]
    )
  end

  test do
    require "json"

    assert_match version.to_s, shell_output("#{bin}/dgop version")

    cpu = JSON.parse(shell_output("#{bin}/dgop cpu --json"))
    memory = JSON.parse(shell_output("#{bin}/dgop memory --json"))

    assert_predicate cpu["count"], :positive?
    assert_predicate memory["total"], :positive?
  end
end
