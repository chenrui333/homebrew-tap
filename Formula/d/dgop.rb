class Dgop < Formula
  desc "API & CLI for System & Process Monitoring"
  homepage "https://danklinux.com/"
  url "https://github.com/AvengeMedia/dgop/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "b35532e10e11fb38c51476fd812dc410a956c96d33bab8dd34b5fc269b791e1a"
  license "MIT"
  head "https://github.com/AvengeMedia/dgop.git", branch: "master"

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.buildTime=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"dgop", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dgop version")

    assert_match "CPU", shell_output("#{bin}/dgop cpu --json")
    assert_match "memory", shell_output("#{bin}/dgop memory --json")
  end
end
