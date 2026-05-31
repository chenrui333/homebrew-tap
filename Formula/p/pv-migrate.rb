class PvMigrate < Formula
  desc "CLI tool to migrate or backup/restore Kubernetes persistent volumes"
  homepage "https://github.com/utkuozdemir/pv-migrate"
  url "https://github.com/utkuozdemir/pv-migrate/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "b96ad3d4ec78fbf6396a9e4a9d2a5755a65b459e02f02c5b9b766d36d8b44de5"
  license "Apache-2.0"
  head "https://github.com/utkuozdemir/pv-migrate.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "117f0d82f5db13e6a21b6f59199c24aa5640e7d20dbb8fa3045d4c1f51d7d093"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e75c160ec46219c9a882c6b9a0dbf67359c7506ff6bdb0de3a7e99eb9f1b0c0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee737de805c743d7b1d28d04617c40ea94bc8d61ee1236918d180de0ea00d102"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3182019dbb5a08c683b0d596213c56eb225cc6632c158a0de1b2247d70706fb"
    sha256 cellar: :any,                 x86_64_linux:  "f4ed6b6d349411194fcf239497a4d6bfd120275112ed4f2ea48db78da9ea6159"
  end

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
