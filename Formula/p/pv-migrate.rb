class PvMigrate < Formula
  desc "CLI tool to migrate or backup/restore Kubernetes persistent volumes"
  homepage "https://github.com/utkuozdemir/pv-migrate"
  url "https://github.com/utkuozdemir/pv-migrate/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "a3ddbbbe97376a240ddb37e0bfd1978b291c9a9ba23cd5883433b00dace2ee9c"
  license "Apache-2.0"
  head "https://github.com/utkuozdemir/pv-migrate.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adb5d44fdd481bd25a1f14b495b3c5b6287a7a1aa98d809748f3f0480a5aee93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25f1d203acb60aa9b32e876534fb38048b615b138ad224d0412eb29c47ab99f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d363e3bc3b694b6d5f43d226321adf0f0480b172031e0605b955c05754f93450"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f8a77597ffcb338171ed25bffa18815ab92d71b0fdbb75286f5e4d244129ea2"
    sha256 cellar: :any,                 x86_64_linux:  "674ab2fcfe1e6e7ab516003137d114acfeb37915a96dac74d27f8e740074dfa6"
  end

  depends_on "go" => :build

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
