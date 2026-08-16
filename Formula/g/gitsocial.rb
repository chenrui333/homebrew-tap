class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "07179f4dc90a2914b91dd0c2dbfaefebd0919b10c92deb8080b367041c6b785a"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89accbbb38065bcf145b735eea3286aa512e8a6df489fac139b3b895dc39e8fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89accbbb38065bcf145b735eea3286aa512e8a6df489fac139b3b895dc39e8fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89accbbb38065bcf145b735eea3286aa512e8a6df489fac139b3b895dc39e8fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1e0e4cb5cee041dfa47517e773c4933628bf6fb8e555b6018055ae7aa5462d7"
    sha256 cellar: :any,                 x86_64_linux:  "fa3a891a36cff21fdbce30dd2add4b10f1acf8ec50bab7917a58b0b585be8e50"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cli/gitsocial"

    generate_completions_from_executable(bin/"gitsocial", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsocial --version 2>&1")
  end
end
