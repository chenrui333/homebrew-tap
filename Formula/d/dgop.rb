class Dgop < Formula
  desc "API & CLI for System & Process Monitoring"
  homepage "https://danklinux.com/"
  url "https://github.com/AvengeMedia/dgop/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "ab97d4bd9483de47051f984ecf3f877d289c316f8a35a9c3d9e5cfaa73b7f2b9"
  license "MIT"
  head "https://github.com/AvengeMedia/dgop.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "359532ca0d865bf2427a4164437fe579b10b665834896e7ff434aad055d052eb"
    sha256 cellar: :any,                 x86_64_linux: "2d8cc358a102d2022345d898a54534e5c9c8376cb2c29e10bc44ecea9f5087a0"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.buildTime=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dgop"

    generate_completions_from_executable bin/"dgop", shell_parameter_format: :cobra
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
