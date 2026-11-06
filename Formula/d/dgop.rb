class Dgop < Formula
  desc "API & CLI for System & Process Monitoring"
  homepage "https://danklinux.com/"
  url "https://github.com/AvengeMedia/dgop/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "6577264abfecedd239062e61f46e838f265dd4fd9244381a28bfddc98fb2def7"
  license "MIT"
  head "https://github.com/AvengeMedia/dgop.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "60eb57e5cd677f08234562c72be767a78bb13e0cb1fac9dc9e3c19a9abb0335f"
    sha256 cellar: :any,                 x86_64_linux: "10acd0bae5c7647eff63309df1e5d6063e2a597afdd4d9e7c0dbfa36e17ac06e"
  end

  depends_on "go" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
