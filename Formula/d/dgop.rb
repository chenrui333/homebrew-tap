class Dgop < Formula
  desc "API & CLI for System & Process Monitoring"
  homepage "https://danklinux.com/"
  url "https://github.com/AvengeMedia/dgop/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "2e45d94d2227bb596844681e66f948aeea4a09be3f7ee88dcbbf38938cabec32"
  license "MIT"
  head "https://github.com/AvengeMedia/dgop.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "e65c25a935653bf3c59b5b7ff216c549932af15bb20884c2b7608a787634a216"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5bf796d64972bce4bd7a7541b668979551b0f55bbc512abbddf511e3dad09707"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.buildTime=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dgop"

    generate_completions_from_executable(bin/"dgop", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
