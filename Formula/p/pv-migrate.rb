class PvMigrate < Formula
  desc "CLI tool to migrate or backup/restore Kubernetes persistent volumes"
  homepage "https://github.com/utkuozdemir/pv-migrate"
  url "https://github.com/utkuozdemir/pv-migrate/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "a3ddbbbe97376a240ddb37e0bfd1978b291c9a9ba23cd5883433b00dace2ee9c"
  license "Apache-2.0"
  head "https://github.com/utkuozdemir/pv-migrate.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eafe8090788095a38cecdf2c47a786826958ebbcffbd90c979fb5daae334098"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a666d79c55a6637cd418521a4e80ebe4cc963bda8ea2ea6f22c9b625e3c2aa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13726e6f75326ec9e6a0c50f0e64845a370f0d7d1c150f29c4a0dbf8367743e8"
    sha256 cellar: :any,                 x86_64_linux:  "04373239106101e81b02a4806cd7d016d9edca9c665d1cdaf3a32cab12b0d7a0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pv-migrate"

    generate_completions_from_executable(bin/"pv-migrate", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pv-migrate --version")
    output = shell_output("#{bin}/pv-migrate migrate 2>&1", 1)
    assert_match "source", output.downcase
  end
end
