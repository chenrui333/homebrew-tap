class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.15.14.tar.gz"
  sha256 "44ef64100c61f20ac0e2f93613f8cff7ecdecc3cfe17d3066ccc2db9171ed4b3"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df3eff41027de1638e28e65e292fd4a9d4bb85f7c0797e50081fbb84f9d18755"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df3eff41027de1638e28e65e292fd4a9d4bb85f7c0797e50081fbb84f9d18755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df3eff41027de1638e28e65e292fd4a9d4bb85f7c0797e50081fbb84f9d18755"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f541438932f3f5636f58af5aa91d10e66b6a005cf0b86786b87768f26a8f2bb8"
    sha256 cellar: :any,                 x86_64_linux:  "9774a6b2742bc5fdb7c3632fb97cb7b83a1ac6c87365ce5a4332c7c9132b951b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    output = shell_output("#{bin}/lfk not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
