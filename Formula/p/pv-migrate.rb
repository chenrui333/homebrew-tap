class PvMigrate < Formula
  desc "CLI tool to migrate or backup/restore Kubernetes persistent volumes"
  homepage "https://github.com/utkuozdemir/pv-migrate"
  url "https://github.com/utkuozdemir/pv-migrate/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "b96ad3d4ec78fbf6396a9e4a9d2a5755a65b459e02f02c5b9b766d36d8b44de5"
  license "Apache-2.0"
  head "https://github.com/utkuozdemir/pv-migrate.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=HEAD
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pv-migrate"

    generate_completions_from_executable(bin/"pv-migrate", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pv-migrate --version")
    output = shell_output("#{bin}/pv-migrate migrate 2>&1", 1)
    assert_match "source", output.downcase
  end
end
