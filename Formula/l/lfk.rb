class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.15.14.tar.gz"
  sha256 "44ef64100c61f20ac0e2f93613f8cff7ecdecc3cfe17d3066ccc2db9171ed4b3"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3e890e85e71132fed19a5d1e01b6c0a3d713e4a3d3f9b232944f415cef8c707"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3e890e85e71132fed19a5d1e01b6c0a3d713e4a3d3f9b232944f415cef8c707"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3e890e85e71132fed19a5d1e01b6c0a3d713e4a3d3f9b232944f415cef8c707"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63e80b63a8984f78c6c7b336fb1401cb275ea47d11981d39dd371578aedc309d"
    sha256 cellar: :any,                 x86_64_linux:  "69634265b4859e37af38d415cd1c3a2c740ebe2e8294164eb6a8b51b0462ae88"
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
