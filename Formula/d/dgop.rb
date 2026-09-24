class Dgop < Formula
  desc "API & CLI for System & Process Monitoring"
  homepage "https://danklinux.com/"
  url "https://github.com/AvengeMedia/dgop/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "1ed7295052f4c368f4e07472c4645e68a75b6d5f9b4cb5cb291a335a7f0d91e6"
  license "MIT"
  head "https://github.com/AvengeMedia/dgop.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "08029cc33b37529425d77bffea8bc3f7e1376aa664acc0037bc3695d0cc00b09"
    sha256 cellar: :any,                 x86_64_linux: "22844d6ade04da5e5a3e1c6e40f040b93b8db5104b2800874a734759d21c3267"
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
